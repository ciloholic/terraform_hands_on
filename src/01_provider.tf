# 本ハンズオンでは、AWS のインフラ構築を行なうため、AWS プロバイダを利用しています
provider "aws" {
  # トークンを設定する
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key

  # 東京リージョンを指定する
  region = "ap-northeast-1"

  # 共通タグを設定する
  default_tags {
    tags = {
      Project     = var.service_name
      Environment = var.env
      Management  = "Terraform"
    }
  }
}
