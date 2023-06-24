locals {
  vpc_cide        = var.vpc_cidr
  total_subnets   = floor(var.total_subnets_count / 2)
  public_subnets  = var.public_subnets_count != null ? var.public_subnets_count : floor(var.total_subnets_count / 2)
  private_subnets = var.private_subnets_count != null ? var.private_subnets_count : floor(var.total_subnets_count / 2)
}

locals {
  enable_vpc_logging          = var.enable_vpc_logging == true ? 1 : 0
  create_cloudwatch_log_group = var.enable_vpc_logging && var.destination_type == "cloud-watch-logs" ? 1 : 0
  create_logging_bucket       = var.enable_vpc_logging && var.destination_type == "s3" ? 1 : 0
}