# VPC configs

## Create VPC
resource "aws_vpc" "umami-vpc" {
  cidr_block = "10.0.0.0/16"
  region = var.aws_region
}

## Public Subnets
resource "aws_subnet" "public-eu-central-1a" {
  vpc_id            = aws_vpc.umami-vpc.id
  availability_zone = "eu-central-1a"
  cidr_block        = "10.0.1.0/24"
}

resource "aws_subnet" "public-eu-central-1b" {
  vpc_id            = aws_vpc.umami-vpc.id
  availability_zone = "eu-central-1b"
  cidr_block        = "10.0.2.0/24"
}

resource "aws_subnet" "public-eu-central-1c" {
  vpc_id            = aws_vpc.umami-vpc.id
  availability_zone = "eu-central-1c"
  cidr_block        = "10.0.3.0/24"
}

## Private Subnets
resource "aws_subnet" "private-eu-central-1a" {
  vpc_id            = aws_vpc.umami-vpc.id
  availability_zone = "eu-central-1a"
  cidr_block        = "10.0.4.0/24"
}

resource "aws_subnet" "private-eu-central-1b" {
  vpc_id            = aws_vpc.umami-vpc.id
  availability_zone = "eu-central-1b"
  cidr_block        = "10.0.5.0/24"
}

resource "aws_subnet" "private-eu-central-1c" {
  vpc_id            = aws_vpc.umami-vpc.id
  availability_zone = "eu-central-1c"
  cidr_block        = "10.0.6.0/24"
}

## IGW and NGW
resource "aws_internet_gateway" "umami-igw" {
  vpc_id = aws_vpc.umami-vpc.id
  region = var.aws_region
}

resource "aws_nat_gateway" "umami-nat" {
  vpc_id = aws_vpc.umami-vpc.id
  connectivity_type = "public"
}

## Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.umami-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.umami-igw.id
  }
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