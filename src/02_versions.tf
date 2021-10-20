terraform {
  # 本ハンズオンは、Terraform のバージョンを `1.0.9` 以上としています
  required_version = "~> 1.0.9"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # AWS プロバイダのバージョンは、ハンズオン作成時の最新としています
      version = "~> 3.63"
    }
  }
}
