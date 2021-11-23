# クラスター
resource "aws_ecs_cluster" "example" {
  name = "${local.service_config.prefix}-fargate-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "${local.service_config.prefix}-fargate-cluster"
  }
}

# サービス
resource "aws_ecs_service" "flask" {
  depends_on                         = [aws_alb.alb]
  name                               = "${local.service_config.prefix}-flask"
  cluster                            = aws_ecs_cluster.example.arn
  task_definition                    = aws_ecs_task_definition.flask.arn
  launch_type                        = "FARGATE"
  health_check_grace_period_seconds  = 60
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200

  lifecycle {
    ignore_changes = [
      desired_count,   # オートスケーリングされる為、ignore_changes に指定する
      task_definition, # デプロイ時に task_definition を上書きする為、ignore_changes に指定する
      load_balancer,   # Blue / Green デプロイで target_group が切り替わる為、ignore_changes に指定する
      platform_version # プラットフォームの更新は CodeDeploy 経由で行う為、ignore_changes に指定する
    ]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.flask["blue"].arn
    container_name   = "${local.service_config.prefix}-flask"
    container_port   = 5000
  }

  network_configuration {
    subnets = [
      for az in local.network_config.availability_zones :
      aws_subnet.private_subnet_fargate[az].id
    ]
    security_groups  = [aws_security_group.flask.id]
    assign_public_ip = false
  }
}

# タスク
resource "aws_ecs_task_definition" "flask" {
  family                   = "${local.service_config.prefix}-flask"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.fargate_execution_role.arn
  execution_role_arn       = aws_iam_role.fargate_execution_role.arn
  cpu                      = 1024
  memory                   = 2048
  container_definitions = jsonencode([{
    "name" : "${local.service_config.prefix}-flask",
    "image" : "flask:latest",
    "essential" : true,
    "portMappings" : [
      {
        "containerPort" : 5000,
        "hostPort" : 5000,
        "protocol" : "tcp"
      }
    ]
  }])

  lifecycle {
    ignore_changes = [
      container_definitions, # デプロイ時に container_definitions を上書きする為、ignore_changes に指定する
      cpu,                   # デプロイ時に更新される為、ignore_changes に指定する
      memory                 # デプロイ時に更新される為、ignore_changes に指定する
    ]
  }
}
