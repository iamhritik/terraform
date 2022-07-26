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

variable "rds_passwd" {
  description = "rds database password"
  type        = string
}