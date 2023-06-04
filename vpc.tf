resource "aws_vpc" "project_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  instance_tenancy     = "default"

  tags = {
    Name = "${var.project}-vpc"
  }
}

resource "aws_subnet" "public-subnet" {
  vpc_id                  = aws_vpc.project_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = "true"
  availability_zone       = "us-east-1a"
  tags = {
    Name = "public"
  }
}

resource "aws_subnet" "private-subnet" {
  vpc_id                  = aws_vpc.project_vpc.id
  cidr_block              = var.private_subnet_cidr
  map_public_ip_on_launch = "false"
  availability_zone       = "us-east-1b"
  tags = {
    Name = "private"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.project_vpc.id

  tags = {
    Name = "${var.project}-igw"
  }
}

resource "aws_eip" "nat-eip" {
  vpc = "true"
}

resource "aws_nat_gateway" "nat-gtw" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.private-subnet.id

  tags = {
    Name = "${var.project}-nat-gtw"
  }
  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public-rtb" {
  vpc_id = aws_vpc.project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project}-public-rtb"
  }
}

resource "aws_route_table_association" "public-rtb-association" {
  subnet_id      = aws_subnet.public-subnet.id
  route_table_id = aws_route_table.public-rtb.id
}

resource "aws_route_table" "private-rtb" {
  vpc_id = aws_vpc.project_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gtw.id
  }

  tags = {
    Name = "${var.project}-private-rtb"
  }
}

resource "aws_route_table_association" "private-rtb-association" {
  subnet_id      = aws_subnet.private-subnet.id
  route_table_id = aws_route_table.private-rtb.id
}



/*

vpc
public subnet
private subnet
internet gateway
elastic ip
nat gateway
---------------------------------------------------------------
eks 
create role which can access master node
security group for master node
add inbound rule through which worker node can interact
add outboud rule for internet
---------------------------------------------------------------
create worker node
create role which can access worker node
security group for worker node
add inbound rule through which master node can interact

*/
