resource "aws_eks_node_group" "nodegroup_1" {
  cluster_name    = aws_eks_cluster.cluster_1.name
  node_group_name = var.eks_nodegroup_name
  version         = var.nodegroup_version
  ami_type        = var.ami_type
  release_version = var.release_version
  capacity_type   = var.capacity_type
  disk_size       = var.disk_size
  instance_types  = var.instance_types
  node_role_arn   = aws_iam_role.nodegroup_role.arn
  subnet_ids      = module.vpc_creation.public_subnets_id
  labels          = var.nodegroup_labels

  dynamic "launch_template" {
    for_each = length(var.launch_template) > 0 ? [var.launch_template] : []
    content {
      id      = try(launch_template.value.id, null)
      version = try(launch_template.value.version, "$Default")
    }
  }

  scaling_config {
    desired_size = var.nodegroup_desired_size
    max_size     = var.nodegroup_max_size
    min_size     = var.nodegroup_min_size
  }

  dynamic "remote_access" {
    for_each = length(var.remote_access) > 0 ? [var.remote_access] : []
    content {
      ec2_ssh_key               = try(remote_access.value.ec2_ssh_key, null)
      source_security_group_ids = try(remote_access.value.source_security_group_ids, aws_security_group.nodegroup_sg.id)
    }
  }

  dynamic "taint" {
    for_each = var.taints
    content {
      key    = taint.value.key
      value  = try(taint.value.value, null)
      effect = taint.value.effect
    }
  }

  dynamic "update_config" {
    for_each = length(var.update_config) > 0 ? [var.update_config] : []
    content {
      max_unavailable_percentage = try(update_config.value.max_unavailable_percentage, null)
      max_unavailable            = try(update_config.value.max_unavailable, null)
    }
  }

  timeouts {
    create = lookup(var.timeouts, "create", null)
    update = lookup(var.timeouts, "update", null)
    delete = lookup(var.timeouts, "delete", null)
  }

  tags = merge(
    try(var.tags, null),
    {
      resource = "${var.cluster_name}-nodegroup"
    }
  )
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}