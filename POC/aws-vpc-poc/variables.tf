variable "vpc_name" {
  default     = "vpc-1"
  description = "vpc name"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC CIDR Block"
}

variable "enable_dns_support" {
  type        = bool
  default     = true
  description = "Enable enable_dns_support"
}

variable "enable_dns_hostnames" {
  type        = bool
  default     = true
  description = "Enable enable_dns_hostnames"
}

variable "availability_zones" {
  type    = list(string)
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}

variable "total_subnets_count" {
  type        = number
  description = "Total number of subnets in this VPC"
  default     = 4
}

variable "public_subnets_count" {
  type        = number
  description = "public subnets count in this VPC"
  default     = null
}

variable "map_public_ip_on_launch" {
  type        = bool
  description = "Enable map_public_ip_on_launch"
  default     = true
}

variable "private_subnets_count" {
  type        = number
  description = "private subnets count in this VPC"
  default     = null
}
