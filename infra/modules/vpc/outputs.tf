output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.umami-vpc.id
}


output "public_subnet_ids" {
  description = "ID of all public subnets"
  value = [
    for subnet in aws_subnet.public :
    subnet.id
  ]
}

output "private_subnet_ids" {
  description = "ID of all private subnets"
  value = [
    for subnet in aws_subnet.private :
    subnet.id
  ]
}

output "igw_id" {
  description = "ID of Internet Gateway"
  value       = aws_internet_gateway.umami-igw.id
}

output "nat_id" {
  description = "ID of NAT Gateway"
  value       = aws_nat_gateway.umami-nat.id
}
