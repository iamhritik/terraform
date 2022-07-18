resource "aws_security_group" "sg1" {
  name        = "web-server-sg"
  description = "web server security group"
  vpc_id      = "vpc-0d692a2f3409a9be1"
  ingress = [
    {
      description      = "HTTP"
      from_port        = 8080
      to_port          = 8080
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


resource "aws_instance" "web-server" {
  ami                    = "ami-006d3995d3a6b963b"
  instance_type          = "t2.micro"
  key_name               = "hritik99"
  vpc_security_group_ids = [aws_security_group.sg1.id]
  subnet_id              = "subnet-0d5f1394a9d1b1c2b"

  root_block_device {
    volume_size           = 8
    volume_type           = "gp3"
    delete_on_termination = true
  }

  user_data = <<-EOF
                #!/bin/bash
                echo "Hello world" > index.html
                nohup busybox httpd -f -p 8080 &
                EOF
  tags = {
    Name   = "web-server"
    source = "terraform-managed"
  }
  depends_on = [aws_security_group.sg1]
}