resource "aws_security_group" "sg1" {
  count       = length(var.naming)
  name        = "${count.index}-sg"
  description = "ansible security group"
  vpc_id      = "vpc-0daa3fe5165c91028"
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
  tags = {
    application = "ansible_sgs"
  }
}


resource "aws_instance" "instance1" {
  depends_on = [aws_security_group.sg1]
  count                  = length(var.naming)
  ami                    = "ami-006d3995d3a6b963b"
  instance_type          = "t2.micro"
  key_name               = "ttn"
  subnet_id              = "subnet-01a2927ff29ebfbb8"
  vpc_security_group_ids = [aws_security_group.sg1[count.index].id]
  availability_zone      = "ap-south-1b"

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
    Name       = var.naming[count.index]
    managed_by = "terraform-managed"
  }
}
