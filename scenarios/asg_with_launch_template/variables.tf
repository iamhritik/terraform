variable "vpc_cidr" {
  description = "VPC CIDR BLOCK"
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = "demo-vpc"
}

variable "ec2_name" {
  description = "EC2 Instance name"
  type        = string
  default     = "web-server"
}