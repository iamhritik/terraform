resource "aws_eks_cluster" "eks-demo" {
  name                      = var.cluster_name
  role_arn                  = aws_iam_role.eks_role.arn
  enabled_cluster_log_types = ["api", "audit"]
  version                   = 1.22
  vpc_config {
    subnet_ids         = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
    security_group_ids = [aws_security_group.sg1.id]

  }
  tags = {
    Name       = "${var.cluster_name}-cluster"
    managed_by = "terraform"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_role-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks_role-AmazonEKSVPCResourceController,
    aws_cloudwatch_log_group.log_group
  ]
}

#cloudwatch log group
resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/eks/${var.cluster_name}/cluster"
  retention_in_days = 7
}


#output section
output "endpoint" {
  value = aws_eks_cluster.eks-demo.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.eks-demo.certificate_authority[0].data
}