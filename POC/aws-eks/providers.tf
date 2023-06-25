terraform {
  required_providers {
    aws = {
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
  default_tags {
    tags = {
      Environment    = "Production"
      Name           = "EKS-cluster-resources"
      provisioned_by = "Terraform"
    }
  }
}