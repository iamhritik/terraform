data "aws_eks_addon_version" "main" {
  for_each = { for k, v in var.eks_cluster_addons : k => v if local.creation }

  addon_name         = try(each.value.name, each.key)
  kubernetes_version = coalesce(var.cluster_version, aws_eks_cluster.cluster_1.version)
  most_recent        = try(each.value.most_recent, null)
}



resource "aws_eks_addon" "main" {
  for_each = { for k, v in var.eks_cluster_addons : k => v if local.creation }

  cluster_name = aws_eks_cluster.cluster_1.name
  addon_name   = try(each.value.name, each.key)

  addon_version               = try(each.value.addon_version, data.aws_eks_addon_version.main[each.key].version)
  configuration_values        = try(each.value.configuration_values, null)
  preserve                    = try(each.value.preserve, null)
  resolve_conflicts_on_create = try(each.value.resolve_conflicts, "OVERWRITE")
  service_account_role_arn    = try(each.value.service_account_role_arn, null)

  timeouts {
    create = try(var.eks_cluster_addons_timeouts.create, null)
    update = try(var.eks_cluster_addons_timeouts.update, null)
    delete = try(var.eks_cluster_addons_timeouts.delete, null)
  }

  depends_on = [
    aws_eks_cluster.cluster_1
  ]

  tags = merge(
    try(var.tags, null),
    {
      resource = "${var.cluster_name}-nodegroup"
    }
  )
}