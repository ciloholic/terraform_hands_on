# パブリックサブネットのネットワーク経路テーブルを設定する
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "${local.service_config.prefix}-public-route-table"
  }
}

# プライベートサブネットのネットワーク経路テーブルを設定する
resource "aws_route_table" "private_route_table" {
  for_each = toset(local.network_config.availability_zones)
  vpc_id   = aws_vpc.example.id

  tags = {
    Name = "${local.service_config.prefix}-private-route-table-${each.value}"
  }
}

# パブリックサブネットのネットワーク経路を設定する
resource "aws_route" "public_route" {
  route_table_id = aws_route_table.public_route_table.id
  # ルーティング先をインターネットゲートウェイに設定する
  gateway_id             = aws_internet_gateway.igw.id
  destination_cidr_block = "0.0.0.0/0"
}

# プライベートサブネットのネットワーク経路を設定する
resource "aws_route" "private_route" {
  for_each       = toset(local.network_config.availability_zones)
  route_table_id = aws_route_table.private_route_table[each.value].id
  # ルーティング先を各 AZ 内の NAT ゲートウェイに設定する
  nat_gateway_id         = aws_nat_gateway.natgw[each.value].id
  destination_cidr_block = "0.0.0.0/0"
}

# パブリックサブネットとルートテーブルを紐付ける
resource "aws_route_table_association" "public_route_table_association_common" {
  for_each       = toset(local.network_config.availability_zones)
  subnet_id      = aws_subnet.public_subnet_common[each.value].id
  route_table_id = aws_route_table.public_route_table.id
}

# プライベートサブネットとルートテーブルを紐付ける
resource "aws_route_table_association" "private_route_table_association_fargate" {
  for_each       = toset(local.network_config.availability_zones)
  subnet_id      = aws_subnet.private_subnet_fargate[each.value].id
  route_table_id = aws_route_table.private_route_table[each.value].id
}

# プライベートサブネットとルートテーブルを紐付ける
resource "aws_route_table_association" "private_route_table_association_storage" {
  for_each       = toset(local.network_config.availability_zones)
  subnet_id      = aws_subnet.private_subnet_storage[each.value].id
  route_table_id = aws_route_table.private_route_table[each.value].id
}
