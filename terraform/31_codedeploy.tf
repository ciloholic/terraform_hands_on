# Flask の CodeDeploy を設定する
resource "aws_codedeploy_app" "flask" {
  name             = "${local.service_config.prefix}-flask"
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "flask" {
  app_name               = aws_codedeploy_app.flask.name
  deployment_group_name  = "${local.service_config.prefix}-flask"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  service_role_arn       = aws_iam_role.codedeploy_role.arn

  auto_rollback_configuration {
    events  = ["DEPLOYMENT_FAILURE"]
    enabled = true
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = local.codedeploy_config.termination_wait_time_in_minutes
    }
  }

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.example.name
    service_name = aws_ecs_service.flask.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_alb_listener.listener.arn]
      }

      dynamic "target_group" {
        for_each = aws_alb_target_group.flask
        content {
          name = target_group.value.name
        }
      }
    }
  }
}
