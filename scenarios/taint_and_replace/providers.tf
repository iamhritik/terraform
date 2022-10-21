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

#terraform taint aws_instance.instance1
#terraform untaint aaws_instance.instance1

#terraform apply -replace="aws_instance.instance1"
