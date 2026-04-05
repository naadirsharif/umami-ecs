# VPC outputs

output "vpc_id" {
    description = "ID of the VPC"
    value = aws_vpc.umami-vpc.id
}

output "public_subnet_ids" {
  description = "ID of all public subnets"
  value = [
    aws_subnet.public-eu-central-1a.id,
    aws_subnet.public-eu-central-1b.id,
    aws_subnet.public-eu-central-1c.id
  ]
}
output "private_subnet_ids" {
  description = "ID of all private subnets"
  value = [
    aws_subnet.private-eu-central-1a.id,
    aws_subnet.private-eu-central-1b.id,
    aws_subnet.private-eu-central-1c.id
  ]
}

output "igw_id" {
    description = "ID of Internet Gateway"
    value = aws_internet_gateway.umami-igw.id
}

output "nat_id" {
    description = "ID of NAT Gateway"
    value = aws_nat_gateway.umami-nat.id
}

