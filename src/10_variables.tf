# 現在のリージョン名を取得(ap-northeast-1)
data "aws_region" "current" {}

variable "aws_access_key" {
  type      = string
  sensitive = true # 標準出力に非表示
}
variable "aws_secret_key" {
  type      = string
  sensitive = true # 標準出力に非表示
}
variable "service_name" {
  type = string
}
variable "env" {
  type = string
}

locals {
  # 共通タグ
  common_tags = {
    Project     = var.service_name
    Environment = var.env
    Management  = "Terraform"
  }
  service_config = {
    name   = var.service_name
    env    = var.env
    prefix = "${var.service_name}-${var.env}"
  }
  aws_config = {
    region = data.aws_region.current.name
  }
  network_config = {
    vpc = {
      cidr_block = "10.0.0.0/16"
    }
    availability_zones = ["a", "c"]
    subnet = {
      "public" = {
        "a" = "10.0.1.0/24"
        "c" = "10.0.2.0/24"
      }
      "private" = {
        "a" = "10.0.11.0/24"
        "c" = "10.0.12.0/24"
      }
    }
  }
}
