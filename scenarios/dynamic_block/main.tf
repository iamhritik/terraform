resource "aws_security_group" "allow_tls" {
  name        = "security group"
  description = "Allow different port traffic"
  vpc_id      = "vpc-0daa3fe5165c91028"

  dynamic "ingress" {
    for_each = var.port_no
    iterator = ports
    content {
      description = "Allow port"
      from_port   = ports.value
      to_port     = ports.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "dynamic-demo-sg"
  }
}