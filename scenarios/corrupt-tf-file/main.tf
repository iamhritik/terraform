resource "aws_security_group" "sg1" {
  name        = "instance1-sg"
  description = "instance1 security group"
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
}

resource "aws_instance" "instance1" {
  ami                    = "ami-098247d860bd88c63"
  instance_type          = "t4g.small"
  key_name               = "ttn"
  subnet_id              = "subnet-0bba78d314ca8eb38"
  vpc_security_group_ids = [aws_security_group.sg1.id]
  availability_zone = "ap-south-1c"

  root_block_device {
    delete_on_termination = true
    encrypted             = true
    volume_size           = 10
    volume_type           = "gp3"
    tags = {
      Name = "instance1-root-vol"
    }
  }

  tags = {
    Name       = "instance-1"
    managed_by = "terraform-managed"
  }
  depends_on = [aws_security_group.sg1]
}