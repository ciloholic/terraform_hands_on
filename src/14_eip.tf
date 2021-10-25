# NAT ゲートウェイ用の Elastic IP を作成する
resource "aws_eip" "natgw" {
  # Elastic IP を作成前にインターネットゲートウェイが必要になる為、明示的に依存関係を設定する
  depends_on = [aws_internet_gateway.igw]

  for_each = toset(local.network_config.availability_zones)
  vpc      = true

  tags = {
    Name = "${local.service_config.prefix}-eip-natgw-${each.value}"
  }
}
