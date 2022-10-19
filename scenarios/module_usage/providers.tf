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



module "webserver_cluster" {
  source   = "./modules/web-server"
  vpc_cidr = "10.0.0.0/16"
  vpc_name = "demo-vpc"
  ec2_name = "web-server-module"
}