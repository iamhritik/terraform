resource "aws_eks_cluster" "cluster_1" {
  name                      = var.cluster_name
  version                   = var.cluster_version
  role_arn                  = aws_iam_role.cluster_role.arn
  enabled_cluster_log_types = try(length(var.eks_cluster_logging), null) != null ? lookup(var.eks_cluster_logging, "log_types", ["api"]) : null

  vpc_config {
    endpoint_private_access = var.private_access     #false
    endpoint_public_access  = var.public_access      #true.
    public_access_cidrs     = var.public_access_cidr #0.0.0.0/0.
    security_group_ids      = var.security_group_ids
    subnet_ids              = module.vpc_creation.public_subnets_id
  }
  kubernetes_network_config {
    service_ipv4_cidr = var.service_ipv4_cidr
    ip_family         = var.ip_family
  }

  depends_on = [
    module.vpc_creation,
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSVPCResourceController,
  ]
}


resource "aws_cloudwatch_log_group" "example" {
  count             = try(length(var.eks_cluster_logging), 0) > 0 ? 1 : 0
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = try(length(var.eks_cluster_logging), null) != null ? lookup(var.eks_cluster_logging, "retentionPeriod", 7) : null
}