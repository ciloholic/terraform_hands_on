# ALB
resource "aws_alb" "alb" {
  # ALB を作成前にインターネットゲートウェイが必要になる為、明示的に依存関係を設定する
  depends_on = [aws_internet_gateway.igw]
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

# リスナー
resource "aws_alb_listener" "listener" {
  load_balancer_arn = aws_alb.alb.arn
  protocol          = "HTTP"
  port              = 80

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.flask["blue"].arn
  }
}

# リスナールール
resource "aws_alb_listener_rule" "listener_rule" {
  listener_arn = aws_alb_listener.listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.flask["blue"].arn
  }

  condition {
    path_pattern {
      values = ["/"]
    }
  }
}

resource "aws_alb_target_group" "flask" {
  for_each    = toset(local.fargate_config.deploy_groups)
  vpc_id      = aws_vpc.example.id
  name        = "${local.service_config.prefix}-flask-${each.key}"
  protocol    = "HTTP"
  port        = 5000
  target_type = "ip"

  health_check {
    path     = "/healthcheck"
    port     = 5000
    interval = 60
    matcher  = "200,304"
  }

  tags = {
    Name = "${local.service_config.prefix}-flask-${each.key}"
  }
}
