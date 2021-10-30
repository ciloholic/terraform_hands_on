terraform {
  # Terraformのバージョンは、ハンズオン作成時の最新としています
  required_version = "1.0.10"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      # AWS プロバイダのバージョンは、ハンズオン作成時の最新としています
      version = "3.63.0"
    }
  }
}
