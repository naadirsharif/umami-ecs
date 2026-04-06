# VPC Variables 

variable "tags" {
  type = map(string)
  default = {
    Project     = "umami"
    Environment = "dev"
  }
}

variable "aws_region" {
    description = "AWS region"
    type        = string
    default     = "eu-central-1"
}

variable "availability_zones" {
    description = "availability zones 1a-1c"
    type        = list(string)
    default     = [
        "eu-central-1a",
        "eu-central-1b",
        "eu-central-1c"
    ]
}

variable "cidr_vpc" {
    description = "CIDR block of VPC"
    type        = string 
    default     = "10.0.0.0/16"
}

variable "cidrs_public_subnet" {
    description = "CIDR blocks of public subnets"
    type        = list(string)
    default     = [
        "10.0.1.0/24",
        "10.0.2.0/24",
        "10.0.3.0/24"
    ]
}

variable "cidrs_private_subnet" {
    description = "CIDR blocks of private subnets"
    type        = list(string)
    default     = [
        "10.0.4.0/24",
        "10.0.5.0/24",
        "10.0.6.0/24"
    ]
}

variable "nat_connectivity_type" {  
    description = "Connectivity type of the NAT gateway"
    type        = string
    default     = "public"
}