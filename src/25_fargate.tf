# Fargate クラスタ
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

# WordPress サービス
resource "aws_ecs_service" "wordpress" {
  depends_on                         = [aws_alb.alb]
  name                               = "${local.service_config.prefix}-wordpress"
  cluster                            = aws_ecs_cluster.example.arn
  task_definition                    = aws_ecs_task_definition.wordpress.arn
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

  #   deployment_controller {
  #     type = "CODE_DEPLOY"
  #   }

  load_balancer {
    target_group_arn = aws_alb_target_group.wordpress["blue"].arn
    container_name   = "wordpress"
    container_port   = 80
  }

  network_configuration {
    subnets = [
      for az in local.network_config.availability_zones :
      aws_subnet.private_subnet_fargate[az].id
    ]
    security_groups  = [aws_security_group.wordpress_fargate.id]
    assign_public_ip = false
  }
}

# WordPress タスク定義
resource "aws_ecs_task_definition" "wordpress" {
  family                   = "${local.service_config.prefix}-wordpress"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  task_role_arn            = aws_iam_role.fargate_execution_role.arn
  execution_role_arn       = aws_iam_role.fargate_execution_role.arn
  cpu                      = 1024
  memory                   = 2048
  container_definitions = jsonencode([{
    "name" : "wordpress",
    "image" : "wordpress:5.8-php8.0-fpm-alpine",
    "essential" : true,
    "portMappings" : [
      {
        "containerPort" : 80,
        "hostPort" : 80,
        "protocol" : "tcp"
      }
    ],
    "environment" : [
      {
        "name" : "WORDPRESS_DB_NAME",
        "value" : "${local.service_config.name}"
      },
      {
        "name" : "WORDPRESS_DB_USER",
        "value" : "${local.aurora_config.master_username}"
      },
      {
        "name" : "WORDPRESS_TABLE_PREFIX",
        "value" : "wp_"
      }
    ],
    "secrets" : [
      {
        "name" : "WORDPRESS_DB_HOST",
        "valueFrom" : "/${local.service_config.name}/${local.service_config.env}/database-host"
      },
      {
        "name" : "WORDPRESS_DB_PASSWORD",
        "valueFrom" : "/${local.service_config.name}/${local.service_config.env}/aurora-master-password"
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
