# 現在のリージョン名を取得(ap-northeast-1)
data "aws_region" "current" {}

variable "aws_access_key" {
  type      = string
  sensitive = true # Terraform の標準出力に非表示
}
variable "aws_secret_key" {
  type      = string
  sensitive = true # Terraform の標準出力に非表示
}
variable "service_name" {
  type = string
}
variable "env" {
  type = string
}

# Terraform 内で利用するローカル変数をまとめて定義
locals {
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
      "common" = {
        "a" = "10.0.1.0/24"
        "c" = "10.0.2.0/24"
      }
      "fargate" = {
        "a" = "10.0.11.0/24"
        "c" = "10.0.12.0/24"
      }
      "storage" = {
        "a" = "10.0.21.0/24"
        "c" = "10.0.22.0/24"
      }
    }
  }
}
