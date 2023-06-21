locals {
  vpc_cide      = var.vpc_cidr
  total_subnets = floor(var.total_subnets_count / 2)
}

locals {
  public_subnets = var.public_subnets_count != null ? var.public_subnets_count : floor(var.total_subnets_count / 2)
}

locals {
  private_subnets = var.private_subnets_count != null ? var.private_subnets_count : floor(var.total_subnets_count / 2)
}



locals {
  create_cloudwatch_log_group = var.destination_type == "cloud-watch-logs" ? 1 : 0
}
locals {
  create_logging_bucket = var.destination_type == "s3" ? 1 : 0
}