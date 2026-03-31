# VPC configs

## Create VPC
resource "aws_vpc" "umami-vpc" {
  cidr_block = var.cidr_vpc
  region = var.aws_region
  tags = var.tags
}

## Public Subnets
resource "aws_subnet" "public-eu-central-1a" {
  vpc_id            = aws_vpc.umami-vpc.id
  availability_zone = var.availability_zones[0]
  cidr_block        = var.cidrs_public_subnet[0]
  tags              = var.tags
}

resource "aws_subnet" "public-eu-central-1b" {
  vpc_id            = aws_vpc.umami-vpc.id
  availability_zone = var.availability_zones[1]
  cidr_block        = var.cidrs_public_subnet[1]
  tags              = var.tags
}

resource "aws_subnet" "public-eu-central-1c" {
  vpc_id            = aws_vpc.umami-vpc.id
  availability_zone = var.availability_zones[1]
  cidr_block        = var.cidrs_public_subnet[2]
  tags              = var.tags
}

## Private Subnets
resource "aws_subnet" "private-eu-central-1a" {
  vpc_id            = aws_vpc.umami-vpc.id
  availability_zone = var.availability_zones[0]
  cidr_block        = var.cidrs_private_subnet[0]
  tags              = var.tags
}

resource "aws_subnet" "private-eu-central-1b" {
  vpc_id            = aws_vpc.umami-vpc.id
  availability_zone = var.availability_zones[1]
  cidr_block        = var.cidrs_private_subnet[1]
  tags              = var.tags
}

resource "aws_subnet" "private-eu-central-1c" {
  vpc_id            = aws_vpc.umami-vpc.id
  availability_zone = var.availability_zones[2]
  cidr_block        = var.cidrs_private_subnet[2]
  tags              = var.tags
}

## IGW and NGW
resource "aws_internet_gateway" "umami-igw" {
  vpc_id = aws_vpc.umami-vpc.id
  region = var.aws_region
  tags   = var.tags
}

resource "aws_nat_gateway" "umami-nat" {
  vpc_id            = aws_vpc.umami-vpc.id
  connectivity_type = var.nat_connectivity_type
  tags              = var.tags
}

## Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.umami-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.umami-igw.id
  }
  tags = var.tags
}

## Public Route Table Assocications
resource "aws_route_table_association" "public_eu_central_1a" {
  subnet_id      = aws_subnet.public-eu-central-1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_eu_central_1b" {
  subnet_id      = aws_subnet.public-eu-central-1b.id
  route_table_id = aws_route_table.public.id
}
resource "aws_route_table_association" "public_eu_central_1c" {
  subnet_id      = aws_subnet.public-eu-central-1c.id
  route_table_id = aws_route_table.public.id
}

## Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.umami-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.umami-nat.id
  }
  tags           = var.tags
}

## Private Route Table Assocications
resource "aws_route_table_association" "private_eu_central_1a" {
  subnet_id      = aws_subnet.private-eu-central-1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_eu_central_1b" {
  subnet_id      = aws_subnet.private-eu-central-1b.id
  route_table_id = aws_route_table.private.id
}
resource "aws_route_table_association" "private_eu_central_1c" {
  subnet_id      = aws_subnet.private-eu-central-1c.id
  route_table_id = aws_route_table.private.id
}



# ALB configs


