#eks cluster security group
resource "aws_security_group" "cluster_sg" {
  name        = "${var.cluster_name}-sg"
  description = "EKS Cluster Security Group"
  vpc_id      = module.vpc_creation.vpc_id

  depends_on = [
    module.vpc_creation
    
    ]

  tags = {
    Name = "${var.cluster_name}-sg"
  }
}

#nodegroup security group
resource "aws_security_group" "nodegroup_sg" {
  name        = "${var.eks_nodegroup_name}-sg"
  description = "EKS NodeGroups Security Group"
  vpc_id      = module.vpc_creation.vpc_id

  depends_on = [
    module.vpc_creation
    ]

  tags = {
    Name = "${var.eks_nodegroup_name}-sg"
  }
}

#cluster SG rules
resource "aws_security_group_rule" "cluster_sg_ingress_01" {
  type              = "ingress"
  security_group_id = aws_security_group.cluster_sg.id
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = []
  ipv6_cidr_blocks  = []
  prefix_list_ids  = []
  source_security_group_id  = []
  self             = true
}

resource "aws_security_group_rule" "cluster_sg_ingress_02" {
  type              = "ingress"
  security_group_id = aws_security_group.cluster_sg.id
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = []
  ipv6_cidr_blocks  = []
  prefix_list_ids  = []
  source_security_group_id  = [aws_security_group.nodegroup_sg.id]
  self             = false
}

resource "aws_security_group_rule" "cluster_sg_egress_01" {
  type              = "egress"
  security_group_id = aws_security_group.cluster_sg.id
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = []
  prefix_list_ids  = []
  source_security_group_id  = []
  self             = false  
}

#nodgroup SG rules
resource "aws_security_group_rule" "nodegroup_sg_ingress_01" {
  type              = "ingress"
  security_group_id = aws_security_group.nodegroup_sg.id
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = []
  prefix_list_ids  = []
  source_security_group_id  = []
  self             = false
}

resource "aws_security_group_rule" "nodegroup_sg_egress_01" {
  type              = "egress"
  security_group_id = aws_security_group.nodegroup_sg.id
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = []
  prefix_list_ids  = []
  source_security_group_id  = []
  self             = false  
}