resource "aws_vpc" "vpc1" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.vpc_name}"
    managed_by = "terraform-managed"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc1.id
  map_public_ip_on_launch = true
  cidr_block        = cidrsubnet(var.vpc_cidr, 1, 0)
  availability_zone = "ap-south-1a"

  tags = {
    Name = "${var.vpc_name}-public-subnet1"
    managed_by = "terraform-managed"
  }
  depends_on = [
    aws_vpc.vpc1
  ]
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 1, 1)
  availability_zone = "ap-south-1b"

  tags = {
    Name = "${var.vpc_name}-private-subnet1"
    managed_by = "terraform-managed"
  }
  depends_on = [
    aws_vpc.vpc1
  ]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "${var.vpc_name}-IGW"
    managed_by = "terraform-managed"
  }
  depends_on = [
    aws_vpc.vpc1
  ]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.vpc_name}-public_route_table"
    managed_by = "terraform-managed"
  }
  depends_on = [
    aws_internet_gateway.igw
  ]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "${var.vpc_name}-private_route_table"
    managed_by = "terraform-managed"
  }
}


resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
  depends_on = [
    aws_route_table.public
  ]
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private.id
  depends_on = [
    aws_route_table.private
  ]
}

#securitygroup creation
resource "aws_security_group" "sg1" {
  name        = "${var.ec2_name}-sg"
  description = "${var.ec2_name} security group"
  vpc_id      = aws_vpc.vpc1.id

  depends_on = [aws_vpc.vpc1]
}


resource "aws_security_group_rule" "allow_ssh_ingress" {
    type = "ingress"
    security_group_id = aws_security_group.sg1.id
    description      = "SSH Access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

}
resource "aws_security_group_rule" "allow_ssh_egress" {
    type = "egress"
    security_group_id = aws_security_group.sg1.id
    description      = "SSH Access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

}

#instance creation
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
      Name = "${var.ec2_name}-root-volume"
    }
  }

  tags = {
    Name       = "${var.ec2_name}"
    managed_by = "terraform-managed"
  }

  depends_on = [aws_security_group.sg1]
}
