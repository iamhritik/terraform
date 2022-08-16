resource "aws_vpc" "vpc1" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc1.id
  map_public_ip_on_launch = true
  cidr_block        = cidrsubnet(var.vpc_cidr, 1, 0)
  availability_zone = "ap-south-1a"

  tags = {
    Name = "${var.vpc_name}-public-subnet1"
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
  }
  depends_on = [
    aws_vpc.vpc1
  ]
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "Demo-IGW"
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
  }
  depends_on = [
    aws_internet_gateway.igw
  ]
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc1.id
  tags = {
    Name = "${var.vpc_name}-private_route_table"
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