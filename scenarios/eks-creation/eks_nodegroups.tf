resource "aws_eks_node_group" "eks_nodegroup1" {
  cluster_name    = aws_eks_cluster.eks-demo.name
  node_group_name = "${var.cluster_name}-nodegroup1"
  node_role_arn   = aws_iam_role.eks_node-group_role.arn
  subnet_ids      = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]

  scaling_config {
    desired_size = 1
    max_size     = 2
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  capacity_type = "SPOT"
  launch_template {
    name    = aws_launch_template.eks-nodegroup-template.name
    version = aws_launch_template.eks-nodegroup-template.latest_version
  }

  tags = {
    Name       = "${var.cluster_name}-nodegroup"
    managed_by = "terraform"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_node-group-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_node-group-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_node-group-AmazonEC2ContainerRegistryReadOnly,
    aws_launch_template.eks-nodegroup-template,
    aws_eks_cluster.eks-demo,
  ]
}