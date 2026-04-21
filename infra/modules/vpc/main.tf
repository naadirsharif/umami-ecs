# VPC module: VPC, subnets, IGW & NAT, routing

## VPC
resource "aws_vpc" "umami-vpc" {
  cidr_block = var.cidr_vpc
  tags       = var.tags
}

## Public Subnets
resource "aws_subnet" "public" {
  for_each = var.cidrs_public_subnet

  vpc_id            = aws_vpc.umami-vpc.id
  availability_zone = var.availability_zones[each.key]
  cidr_block        = each.value

  tags = var.tags
}

## Private Subnets
resource "aws_subnet" "private" {
  for_each = var.cidrs_private_subnet

  vpc_id            = aws_vpc.umami-vpc.id
  availability_zone = var.availability_zones[each.key]
  cidr_block        = each.value

  tags              = var.tags
}


## IGW and NGW
resource "aws_internet_gateway" "umami-igw" {
  vpc_id = aws_vpc.umami-vpc.id
  tags   = var.tags
}

resource "aws_nat_gateway" "umami-nat" {
  availability_mode = var.availability_mode
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
resource "aws_route_table_association" "public" {
  for_each = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

## Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.umami-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.umami-nat.id
  }
  tags = var.tags
}

## Private Route Table Assocications
resource "aws_route_table_association" "private" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private.id
}

