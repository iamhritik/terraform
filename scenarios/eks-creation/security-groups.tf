resource "aws_security_group" "sg1" {
  name        = "${var.cluster_name}-sg1"
  description = "${var.cluster_name} security group"
  vpc_id      = aws_vpc.vpc1.id
  ingress = [
    {
      description      = "API Access"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Allow inbound traffic from itself"
      from_port        = 0
      to_port          = 0
      protocol         = -1
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = true
    }
  ]

  egress = [
    {
      description      = "Allow all Traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  tags = {
    Name       = "${var.cluster_name}-sg1"
    managed_by = "terraform"
  }

  depends_on = [aws_vpc.vpc1]
}


#nodegroup launch template securitygroup
resource "aws_security_group" "sg2" {
  name        = "${var.cluster_name}-sg2"
  description = "${var.cluster_name} nodegroup security group"
  vpc_id      = aws_vpc.vpc1.id
  ingress = [
    {
      description      = "API Access"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    },
    {
      description      = "Allow inbound traffic from cluster SG"
      from_port        = 0
      to_port          = 0
      protocol         = -1
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = ["${aws_security_group.sg1.id}"]
      self             = false
    }
  ]

  egress = [
    {
      description      = "Allow all Traffic"
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]
  tags = {
    Name       = "${var.cluster_name}-sg2"
    managed_by = "terraform"
  }

  depends_on = [aws_vpc.vpc1]
}