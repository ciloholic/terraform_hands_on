resource "aws_nat_gateway" "natgw" {
  # NAT ゲートウェイを作成前にインターネットゲートウェイが必要になる為、
  # 明示的に依存関係を設定する
  depends_on = [aws_internet_gateway.igw]
  for_each   = toset(local.network_config.availability_zones)
  # NAT ゲートウェイの Elastic IP を設定する
  allocation_id = aws_eip.natgw[each.value].id
  subnet_id     = aws_subnet.public_subnet[each.value].id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.service_config.prefix}-nat-gateway-${each.key}"
    }
  )
}
