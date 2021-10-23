resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "${local.service_config.prefix}-igw"
  }
}
