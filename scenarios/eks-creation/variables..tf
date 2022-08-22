variable "vpc_cidr" {
  description = "VPC CIDR BLOCK"
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = "demo"
}

variable "cluster_name" {
  description = "EKS Cluster Name"
  type        = string
  default     = "eks-demo"
}