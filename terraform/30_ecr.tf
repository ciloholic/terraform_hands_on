# Flask の リポジトリを作成する
resource "aws_ecr_repository" "flask" {
  name                 = "${local.service_config.prefix}-flask"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${local.service_config.prefix}-ecr-flask"
  }
}
