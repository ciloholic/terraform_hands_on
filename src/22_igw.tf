resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.example.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.service_config.prefix}-igw"
    }
  )
}
