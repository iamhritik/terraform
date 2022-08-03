# resource "aws_iam_user" "users" {
#     #count = length(var.usernames)
#     #name = var.usernames[count.index]
#     for_each = toset(var.usernames)
#     name = each.value
# }

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_security_group" "sg1" {
    name        = "web-server-sg"
    description = "web server security group"
    vpc_id      = data.aws_vpc.default.id
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
      },
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
  


resource "aws_security_group" "lb_sg" {
    name        = "lb_sg"
    description = "lb_sg security group"
    ingress = [
      {
        description      = "HTTP"
        from_port        = 80
        to_port          = 80
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

resource "aws_launch_template" "demo-temp" {
  name                   = "demo-temp"
  image_id               = "ami-006d3995d3a6b963b"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg1.id]

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size           = 8
      delete_on_termination = true
      volume_type           = "gp3"
    }
  }
  user_data = filebase64("userdata.sh")
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name   = "httpd-server"
      source = "terraform-managed"
    }
  }

}



resource "aws_lb_target_group" "demo-tg" {
  name     = "tf-example-lb-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 4
    timeout             = 5
    interval            = 15
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
  }

}



resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.demo-alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.demo-tg.arn
  }
  depends_on = [aws_lb_target_group.demo-tg]
}



resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100
  condition {
    path_pattern {
      values = ["*"]
    }
  }
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.demo-tg.arn
  }

}



resource "aws_lb" "demo-alb" {
  name               = "demo-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = data.aws_subnet_ids.default.ids
  tags = {
    Environment = "production"
  }
}



resource "aws_autoscaling_group" "demo-asg" {
  name                = "demo-asg"
  desired_capacity    = 3
  max_size            = 3
  min_size            = 3
  vpc_zone_identifier = data.aws_subnet_ids.default.ids
  target_group_arns   = [aws_lb_target_group.demo-tg.arn]
  health_check_type   = "ELB"

  launch_template {
    id      = aws_launch_template.demo-temp.id
    version = "$Latest"
  }
  dynamic "tag" {
    for_each = var.custom_tags
    content {
        key = tag.key
        value = tag.value
        propagate_at_launch = true
    }
  }
  depends_on = [aws_launch_template.demo-temp]
}



output "alb_dns_name" {
    value = aws_lb.demo-alb.dns_name
    description = "ALB DNS name"
}