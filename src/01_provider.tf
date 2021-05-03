# 本ハンズオンでは、AWS のインフラ構築を行う為、AWSプロバイダを利用しています。
provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  # 東京リージョンにインフラ構築を行います
  region = "ap-northeast-1"
}
