resource "aws_security_group" "sg1" {
  name        = "${var.ec2_name}-sg"
  description = "${var.ec2_name} security group"
  vpc_id      = aws_vpc.vpc1.id
  ingress = [
    {
      description      = "SSH Access"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
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
  depends_on = [aws_vpc.vpc1]
}



resource "aws_instance" "instance1" {
  ami                    = "ami-098247d860bd88c63"
  instance_type          = "t4g.small"
  key_name               = "ttn"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.sg1.id]
  availability_zone = "ap-south-1a"

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 10
    volume_type           = "gp3"
    tags = {
      Name = "web-server-root-vol"
    }
  }

  tags = {
    Name       = "${var.ec2_name}"
    managed_by = "terraform-managed"
  }

  depends_on = [aws_security_group.sg1]
}

output "ec2_public_ip" {
  value = aws_instance.instance1.public_ip
  sensitive   = false
}