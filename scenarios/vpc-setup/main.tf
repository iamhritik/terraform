resource "aws_vpc" "vpc1" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "Demo-VPC"
  }
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

resource "aws_subnet" "public_subnet" {
    vpc_id = aws_vpc.vpc1.id
    cidr_block = "10.0.0.0/17"
    availability_zone = "ap-south-1a"

    tags = {
        Name = "Public-subnet1"
    }
    depends_on = [
        aws_vpc.vpc1
    ]
}

resource "aws_subnet" "private_subnet" {
    vpc_id = aws_vpc.vpc1.id
    cidr_block = "10.0.128.0/17"
    availability_zone = "ap-south-1b"

    tags = {
        Name = "Private-subnet1"
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
        Name = "Public_route_table"
    }
    depends_on = [
        aws_internet_gateway.igw
    ]
}

resource "aws_route_table" "private" {
    vpc_id = aws_vpc.vpc1.id
    tags = {
        Name = "Private_route_table"
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