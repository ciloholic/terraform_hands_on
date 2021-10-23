resource "aws_vpc" "example" {
  # "10.0.0.0/16" の VPC を作成する
  cidr_block = local.network_config.vpc.cidr_block

  tags = {
    Name = "${local.service_config.prefix}-vpc"
  }
}
