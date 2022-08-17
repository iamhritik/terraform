#s3 bucket to store alb access logs
resource "aws_s3_bucket" "alb_logs" {
  bucket = "asmathalblogs"

  tags = {
    Name        = "asmath_alb_logs"
    Environment = "Dev"
  }
}


#Security Group creation
resource "aws_security_group" "alb_sg1" {
  name        = "demo-alb-sg1"
  description = "demo-alb-sg1 security group"
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

#Target group creation
resource "aws_lb_target_group" "demo-tg" {
  name     = "demo-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc1.id
}


#ALB Creation
resource "aws_lb" "alb1" {
  name               = "demo-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg1.id]
  subnets            = ["${aws_subnet.public_subnet1.id}", "${aws_subnet.public_subnet2.id}"]

#will work on this
  # access_logs {
  #   bucket  = "${aws_s3_bucket.alb_logs.bucket}"
  #   prefix  = "alb-access-logs"
  #   enabled = true
  # }

  tags = {
    Name        = "demo-alb"
    Environment = "demo"
    owner       = "terraform-managed"
  }
}

#ALB listender rule
resource "aws_lb_listener" "default-listender" {
  load_balancer_arn = "${aws_lb.alb1.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.demo-tg.arn
  }
}

