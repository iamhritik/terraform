provider "aws" {
  region = "ap-south-1"
}

# terraform {
#   backend "s3" {
#     bucket = "tf-lock-demo"
#     key = "global/s3/terraform.tfstate"
#     region = "ap-south-1"
#     dynamodb_table = "terraform-lock"
#     encrypt = false
#   }
# }