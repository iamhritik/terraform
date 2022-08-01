variable "server_port" {
  description = "the port of the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "server_port_ssh" {
  description = "the port of the server will use for HTTP requests"
  type        = number
  default     = 22
}

variable "security_group_name" {
  description = "security group name"
  type = string
}

variable "instance_name" {
  description = "name of the ec2 instance"
  type = string
}