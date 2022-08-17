#Security Group creation
resource "aws_security_group" "launch_template_sg1" {
  name        = "demo-alb-sg"
  description = "demo-alb-sg security group"
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
    },
    {
      description      = "HTTP Access"
      from_port        = 80
      to_port          = 80
      cidr_blocks      = []
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = ["${aws_security_group.alb_sg1.id}"]
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

resource "aws_launch_template" "demo-template" {
  name = "demo-launch-template"

  block_device_mappings {
    device_name = "/dev/sda1"

    ebs {
      volume_size = 10
      volume_type = "gp3"
      encrypted   = true
    }
  }
  iam_instance_profile {
    arn = "arn:aws:iam::766418871530:instance-profile/ec2-role-Instance-Profile"
  }

  image_id                             = "ami-006d3995d3a6b963b"
  instance_initiated_shutdown_behavior = "stop"
  instance_type                        = "t2.micro"
  key_name                             = "ttn"
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }
  placement {
    availability_zone = "ap-south-1a"
  }
  vpc_security_group_ids = ["${aws_security_group.launch_template_sg1.id}"]
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name  = "demo-launch-template-instances"
      owner = "terraform-managed"
    }
  }

  user_data = filebase64("${path.module}/userdata.sh")
}

