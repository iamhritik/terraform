terraform {
  required_providers {
    aws = {
      version = "~> 4.0"
    }
  }
    backend "s3" {
    # Replace this
        bucket = "tothenewaccount"
        key = "workspaces-example/terraform.tfstate"
        region = "ap-south-1"
        dynamodb_table = "terraform-state"
        encrypt = true
    }
}

provider "aws" {
  region = "ap-south-1"
}

#workspace commands
#terraform workspace show

#terraform workspace new workspace_name

#terraform workspace list
#terraform workspace select workspace_name