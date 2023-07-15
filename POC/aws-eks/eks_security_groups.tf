#nodegroup security group
resource "aws_security_group" "nodegroup_sg" {
  name        = "${var.eks_nodegroup_name}-sg"
  description = "EKS NodeGroups Security Group"
  vpc_id      = var.vpc_id
  tags = {
    Name = "${var.eks_nodegroup_name}-sg"
  }
}


#nodgroup SG rules
resource "aws_security_group_rule" "nodegroup_sg_ingress_01" {
  type              = "ingress"
  security_group_id = aws_security_group.nodegroup_sg.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "nodegroup_sg_egress_01" {
  type              = "egress"
  security_group_id = aws_security_group.nodegroup_sg.id
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
}