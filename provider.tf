terraform {
  required_version = "~> 1.4.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.63.0"
    }
  }
}
# AWS プロバイダの設定
provider "aws" {
  region = "ap-northeast-1"
}

provider "archive" {}
