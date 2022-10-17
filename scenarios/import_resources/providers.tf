terraform {
  required_providers {
    aws = {
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region = "ap-south-1"
}