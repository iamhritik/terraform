variable "ami_id" {
  type        = string
  default     = null
  description = "Enter ec2 instance ami_id"
}

variable "instance_type" {
  type        = string
  default     = null
  description = "Enter ec2 instance instance_type"
}

variable "key_name" {
  type        = string
  default     = null
  description = "Enter ec2 instance key_name"
}

variable "subnet_id" {
  type        = string
  default     = null
  description = "Enter ec2 instance subnet_id"
}

variable "security_group_id" {
  type        = string
  default     = null
  description = "Enter ec2 instance security_group_id"
}

variable "az" {
  type        = string
  default     = null
  description = "Enter ec2 instance az"
}

variable "volume_size" {
  type        = number
  default     = null
  description = "Enter ec2 instance volume_size"
}

variable "volume_type" {
  type        = string
  default     = null
  description = "Enter ec2 instance volume_type"
}

variable "source_file_location" {
  type        = string
  default     = null
  description = "Enter ec2 instance source_file_location"
}
