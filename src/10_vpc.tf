resource "aws_vpc" "example" {
  # "10.0.0.0/16" の VPC を作成する
  cidr_block = local.network_config.vpc.cidr_block
  # PrivateLink用
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${local.service_config.prefix}-vpc"
  }
}
