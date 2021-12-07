# 現在の AWS アカウント ID を取得する
data "aws_caller_identity" "current" {}
# 現在のリージョン名を取得する(ap-northeast-1)
data "aws_region" "current" {}

variable "aws_access_key" {
  type      = string
  sensitive = true # Terraform の標準出力に表示しないようにする
}
variable "aws_secret_key" {
  type      = string
  sensitive = true # Terraform の標準出力に表示しないようにする
}
variable "service_name" {
  type = string
}
variable "env" {
  type = string
}
variable "aurora_master_username" {
  type = string
}
variable "aurora_engine_version" {
  type = string
}
variable "aurora_cluster_instance_count" {
  type = number
}
variable "aurora_instance_class" {
  type = string
}
variable "fargate_min_capacity" {
  type = number
}
variable "fargate_max_capacity" {
  type = number
}
variable "codedeploy_termination_wait_time_in_minutes" {
  type = number
}

# Terraform 内で利用するローカル変数をまとめて定義する
locals {
  service_config = {
    name   = var.service_name
    env    = var.env
    prefix = "${var.service_name}-${var.env}"
  }
  aws_config = {
    aws_account_id = data.aws_caller_identity.current.account_id
    region         = data.aws_region.current.name
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
  aurora_config = {
    master_username        = var.aurora_master_username
    family                 = "aurora-mysql5.7"
    engine                 = "aurora-mysql"
    engine_version         = var.aurora_engine_version
    cluster_instance_count = var.aurora_cluster_instance_count
    instance_class         = var.aurora_instance_class
    ca_cert_identifier     = "rds-ca-2019"
  }
  fargate_config = {
    deploy_groups = ["blue", "green"]
    min_capacity  = var.fargate_min_capacity
    max_capacity  = var.fargate_max_capacity
  }
  codedeploy_config = {
    termination_wait_time_in_minutes = var.codedeploy_termination_wait_time_in_minutes
  }
}
