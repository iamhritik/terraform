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
