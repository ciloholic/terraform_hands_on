# ECR、CloudWatch logs、SSM の VPC エンドポイントを設定する
resource "aws_vpc_endpoint" "example" {
  for_each = toset([
    "ecr.api",
    "ecr.dkr",
    "logs",
    "ec2messages",
    "ssm",
    "ssmmessages"
  ])
  vpc_id            = aws_vpc.example.id
  service_name      = "com.amazonaws.${local.aws_config.region}.${each.value}"
  vpc_endpoint_type = "Interface"
  subnet_ids = [
    for az in local.network_config.availability_zones :
    aws_subnet.private_subnet_fargate[az].id
  ]
  security_group_ids  = [aws_security_group.vpc_endpoint.id]
  private_dns_enabled = true

  tags = {
    Name = "${local.service_config.prefix}-${replace(each.value, ".", "-")}"
  }
}
