output "eks_endpoint" {
  value       = aws_eks_cluster.cluster_1.endpoint
  sensitive   = false
  description = "EKS Cluster endpoint"
  depends_on = [
    aws_eks_cluster.cluster_1
  ]
}
