variable "port_no" {
  description = "security group port numbers"
  type        = list(any)
  default     = [22, 80]
}