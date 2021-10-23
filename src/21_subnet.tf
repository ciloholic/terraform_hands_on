resource "aws_subnet" "public_subnet" {
  # "10.0.1.0/24" と "10.0.2.0/24" のサブネットを作成する
  for_each          = local.network_config.subnet.public
  vpc_id            = aws_vpc.example.id
  availability_zone = "${local.aws_config.region}${each.key}"
  cidr_block        = each.value

  tags = {
    Name = "${local.service_config.prefix}-public-subnet-${each.key}"
  }
}

resource "aws_subnet" "private_subnet" {
  # "10.0.11.0/24" と "10.0.12.0/24" のサブネットを作成する
  for_each          = local.network_config.subnet.private
  vpc_id            = aws_vpc.example.id
  availability_zone = "${local.aws_config.region}${each.key}"
  cidr_block        = each.value

  tags = {
    Name = "${local.service_config.prefix}-private-subnet-${each.key}"
  }
}
