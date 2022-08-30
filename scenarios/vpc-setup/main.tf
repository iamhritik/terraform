resource "aws_vpc" "vpc1" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.vpc_name}-vpc"
  }
}
#public subnets
resource "aws_subnet" "public_subnets" {
  count = 2
  vpc_id                  = aws_vpc.vpc1.id
  map_public_ip_on_launch = true
  cidr_block              = cidrsubnet(var.vpc_cidr, 2, count.index)
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "${var.vpc_name}-public-subnet-${format("%d", count.index + 1)}"
  }
  depends_on = [
    aws_vpc.vpc1
  ]
}

#private subnets
resource "aws_subnet" "private_subnets" {
  count = 2
  vpc_id            = aws_vpc.vpc1.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 2, format("%d", count.index + 2))
  availability_zone = "ap-south-1a"

  tags = {
    Name = "${var.vpc_name}-private-subnet-${format("%d", count.index + 1)}"
  }
  depends_on = [
    aws_vpc.vpc1
  ]
}

#Internet G/W
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc1.id

  tags = {
    Name = "${var.vpc_name}-IGW"
  }
  depends_on = [
    aws_vpc.vpc1
  ]
}


#Route table
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


#Route table association
resource "aws_route_table_association" "public" {
  count = 2
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id
  depends_on = [
    aws_route_table.public
  ]
}

resource "aws_route_table_association" "private" {
  count = 2
  subnet_id      = "${aws_subnet.private_subnets[count.index].id}"
  route_table_id = aws_route_table.private.id
  depends_on = [
    aws_route_table.private
  ]
}