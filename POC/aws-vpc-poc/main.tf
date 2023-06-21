resource "aws_vpc" "vpc_1" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = var.enable_dns_support
  enable_dns_hostnames = var.enable_dns_hostnames
  tags = {
    Name = "${var.vpc_name}"
  }
}
#public subnets
resource "aws_subnet" "public_subnets" {
  count                   = local.public_subnets
  vpc_id                  = aws_vpc.vpc_1.id
  map_public_ip_on_launch = var.map_public_ip_on_launch
  cidr_block              = cidrsubnet(var.vpc_cidr, local.total_subnets, count.index)
  availability_zone       = element(var.availability_zones, count.index % length(var.availability_zones))

  tags = {
    Name = "${var.vpc_name}-public-subnet-${format("%d", count.index + 1)}"
  }
  depends_on = [
    aws_vpc.vpc_1
  ]
}

#private subnets
resource "aws_subnet" "private_subnets" {
  count             = local.private_subnets
  vpc_id            = aws_vpc.vpc_1.id
  cidr_block        = cidrsubnet(var.vpc_cidr, local.total_subnets, format("%d", count.index + local.public_subnets))
  availability_zone = element(var.availability_zones, count.index % length(var.availability_zones))

  tags = {
    Name = "${var.vpc_name}-private-subnet-${format("%d", count.index + 1)}"
  }
  depends_on = [
    aws_vpc.vpc_1
  ]
}

#Internet G/W
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc_1.id

  tags = {
    Name = "${var.vpc_name}-IGW"
  }
  depends_on = [
    aws_vpc.vpc_1
  ]
}


#Route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc_1.id
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

#used default route table as private route table
resource "aws_default_route_table" "default_route" {
  default_route_table_id = aws_vpc.vpc_1.default_route_table_id
  route                  = []
  tags = {
    Name = "${var.vpc_name}-private_route_table"
  }
}

#Route table association
resource "aws_route_table_association" "public" {
  count          = local.public_subnets
  subnet_id      = aws_subnet.public_subnets[count.index].id
  route_table_id = aws_route_table.public.id
  depends_on = [
    aws_route_table.public
  ]
}

resource "aws_route_table_association" "private" {
  count          = local.private_subnets
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_default_route_table.default_route.id
  depends_on = [
    aws_default_route_table.default_route
  ]
}