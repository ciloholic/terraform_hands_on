# VPC エンドポイント
resource "aws_security_group" "vpc_endpoint" {
  vpc_id = aws_vpc.example.id
  name   = "${local.service_config.prefix}-vpc-endpoint"

  tags = {
    Name = "${local.service_config.prefix}-vpc-endpoint"
  }
}

resource "aws_security_group_rule" "vpc_endpoint_ingress_1" {
  security_group_id = aws_security_group.vpc_endpoint.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443
  cidr_blocks = [
    for az in local.network_config.availability_zones :
    aws_subnet.private_subnet_fargate[az].cidr_block
  ]
}

# 踏み台サーバ
resource "aws_security_group" "step_server" {
  vpc_id = aws_vpc.example.id
  name   = "${local.service_config.prefix}-step-server"

  tags = {
    Name = "${local.service_config.prefix}-step-server"
  }
}

resource "aws_security_group_rule" "step_server_egress_1" {
  security_group_id = aws_security_group.step_server.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

# Aurora
resource "aws_security_group" "aurora" {
  vpc_id = aws_vpc.example.id
  name   = "${local.service_config.prefix}-aurora"

  tags = {
    Name = "${local.service_config.prefix}-aurora"
  }
}

resource "aws_security_group_rule" "aurora_ingress_1" {
  for_each          = toset(local.network_config.availability_zones)
  security_group_id = aws_security_group.aurora.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 3306
  to_port           = 3306
  cidr_blocks = [
    aws_subnet.public_subnet_common[each.value].cidr_block,
    aws_subnet.private_subnet_fargate[each.value].cidr_block
  ]
}

resource "aws_security_group_rule" "aurora_egress_1" {
  security_group_id = aws_security_group.aurora.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

# ALB
resource "aws_security_group" "alb" {
  vpc_id = aws_vpc.example.id
  name   = "${local.service_config.prefix}-alb"

  tags = {
    Name = "${local.service_config.prefix}-alb"
  }
}

resource "aws_security_group_rule" "alb_ingress_1" {
  security_group_id = aws_security_group.alb.id
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_egress_1" {
  security_group_id = aws_security_group.alb.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

# WordPress
resource "aws_security_group" "wordpress" {
  vpc_id = aws_vpc.example.id
  name   = "${local.service_config.prefix}-wordpress"

  tags = {
    Name = "${local.service_config.prefix}-wordpress"
  }
}

resource "aws_security_group_rule" "wordpress_ingress_1" {
  security_group_id        = aws_security_group.wordpress.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 80
  to_port                  = 80
  source_security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "wordpress_egress_1" {
  security_group_id = aws_security_group.wordpress.id
  type              = "egress"
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}
