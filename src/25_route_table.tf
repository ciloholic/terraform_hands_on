resource "aws_route_table" "public_route_table" {
  for_each = toset(local.network_config.availability_zones)
  vpc_id   = aws_vpc.example.id

  tags = {
    Name = "${local.service_config.prefix}-public-route-table-${each.value}"
  }
}

resource "aws_route_table" "private_route_table" {
  for_each = toset(local.network_config.availability_zones)
  vpc_id   = aws_vpc.example.id

  tags = {
    Name = "${local.service_config.prefix}-private-route-table-${each.value}"
  }
}

resource "aws_route" "public_route" {
  for_each               = toset(local.network_config.availability_zones)
  route_table_id         = aws_route_table.public_route_table[each.value].id
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route" "private_route" {
  for_each       = toset(local.network_config.availability_zones)
  route_table_id = aws_route_table.private_route_table[each.value].id
  # Avaliability Zone 毎に接続する NAT ゲートウェイを切り替える
  nat_gateway_id         = aws_nat_gateway.natgw[each.value].id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_route_table_association" "public_route_table_association" {
  for_each       = toset(local.network_config.availability_zones)
  subnet_id      = aws_subnet.public_subnet[each.value].id
  route_table_id = aws_route_table.public_route_table[each.value].id
}

resource "aws_route_table_association" "private_route_table_association" {
  for_each       = toset(local.network_config.availability_zones)
  subnet_id      = aws_subnet.private_subnet[each.value].id
  route_table_id = aws_route_table.private_route_table[each.value].id
}
