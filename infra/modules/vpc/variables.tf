variable "tags" {
  type = map(string)
}

variable "availability_zones" {
    description = "availability zones 1a-1c"
    type        = list(string)
}

variable "cidr_vpc" {
    description = "CIDR block of VPC"
    type        = string 
}

variable "cidrs_public_subnet" {
    description = "CIDR blocks of public subnets"
    type        = list(string)
}

variable "cidrs_private_subnet" {
    description = "CIDR blocks of private subnets"
    type        = list(string)
}

variable "nat_connectivity_type" {  
    description = "Connectivity type of the NAT gateway"
    type        = string
    default     = "public"
}