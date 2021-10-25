# ALB
resource "aws_alb" "alb" {
  name            = "${local.service_config.prefix}-alb"
  security_groups = [aws_security_group.alb.id]
  subnets = [
    for az in local.network_config.availability_zones :
    aws_subnet.public_subnet_common[az].id
  ]
  internal = false # 外向き

  tags = {
    Name = "${local.service_config.prefix}-alb"
  }
}

resource "aws_alb_listener" "alb" {
  load_balancer_arn = aws_alb.alb.arn
  protocol          = "HTTP"
  port              = 80

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.wordpress["blue"].arn
  }
}

resource "aws_alb_listener_rule" "alb" {
  listener_arn = aws_alb_listener.alb.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.wordpress["blue"].arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

resource "aws_alb_target_group" "wordpress" {
  for_each    = toset(local.fargate_config.deploy_groups)
  vpc_id      = aws_vpc.example.id
  name        = "${local.service_config.prefix}-wordpress-${each.key}"
  protocol    = "HTTP"
  port        = 80
  target_type = "ip"

  health_check {
    path                = "/wp-admin/install.php"
    port                = 80
    interval            = 60
    unhealthy_threshold = 5
    matcher             = "200,304"
  }

  tags = {
    Name = "${local.service_config.prefix}-wordpress-${each.key}"
  }
}
