variable "vpc_cidr" {
  description = "VPC CIDR BLOCK"
}

variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = "demo-vpc"
}

variable "ec2_name" {
  description = "Ec2 instance name"
  type = string
}
