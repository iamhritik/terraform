variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC CIDR Block"
}

variable "vpc_name" {
    default = "demo-vpc"
    description = "vpc name"
}