# 本ハンズオンでは、AWSのインフラ構築を行なうため、AWSプロバイダを利用しています
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

  # 東京リージョンを指定
  region = "ap-northeast-1"

  # 共通タグを設定
  default_tags {
    tags = {
      Project     = var.service_name
      Environment = var.env
      Management  = "Terraform"
    }
  }
}
