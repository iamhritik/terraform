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


#flow-logs related variables
variable "destination_type" {
  type        = string
  default     = "cloud-watch-logs"
  description = "VPC Flow logging - s3 or cloud-watch-logs"
}

variable "log_format" {
  type        = string
  default     = null
  description = "VPC flow logs format"
}

variable "iam_role_arn" {
  type        = string
  default     = null
  description = "IAM Role ARN for vpc-flow-logs"
}

variable "traffic_type" {
  type        = string
  default     = "ALL"
  description = "VPC flow logs - traffic type:[ALL,ACCEPT,REJECT]"
}

variable "max_aggregation_interval" {
  type        = number
  default     = 600
  description = "The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record."
}

variable "cloudwatch_log_group_name" {
  type        = string
  default     = null
  description = "cloudwatch log_group name"
}

variable "logging_bucket_name" {
  type        = string
  default     = null
  description = "vpc logging s3 bucket name"
}

variable "flow_log_file_format" {
  type        = string
  default     = "plain-text"
  description = "vpc flow_log_file_format"
}

variable "flow_log_hive_compatible_partitions" {
  type        = bool
  default     = false
  description = "vpc flow_log_hive_compatible_partitions"
}

variable "flow_log_per_hour_partition" {
  type        = bool
  default     = false
  description = "vpc flow_log_per_hour_partition"
}