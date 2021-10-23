# "10.0.1.0/24" と "10.0.2.0/24" のサブネットを作成する
resource "aws_subnet" "public_subnet_common" {
  for_each   = local.network_config.subnet.common
  cidr_block = each.value

  vpc_id            = aws_vpc.example.id
  availability_zone = "${local.aws_config.region}${each.key}"

  tags = {
    Name = "${local.service_config.prefix}-public-subnet-${each.key}-common"
  }
}

# "10.0.11.0/24" と "10.0.12.0/24" のサブネットを作成する
resource "aws_subnet" "private_subnet_fargate" {
  for_each   = local.network_config.subnet.fargate
  cidr_block = each.value

  vpc_id            = aws_vpc.example.id
  availability_zone = "${local.aws_config.region}${each.key}"

  tags = {
    Name = "${local.service_config.prefix}-private-subnet-${each.key}-fargate"
  }
}

# "10.0.21.0/24" と "10.0.22.0/24" のサブネットを作成する
resource "aws_subnet" "private_subnet_storage" {
  for_each   = local.network_config.subnet.storage
  cidr_block = each.value

  vpc_id            = aws_vpc.example.id
  availability_zone = "${local.aws_config.region}${each.key}"

  tags = {
    Name = "${local.service_config.prefix}-private-subnet-${each.key}-storage"
  }
}
