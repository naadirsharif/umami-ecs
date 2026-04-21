variable "tags" {
  type = map(string)
}

variable "availability_zones" {
  type        = map(string)
}

variable "cidr_vpc" {
  description = "CIDR block of VPC"
  type        = string
}

variable "cidrs_public_subnet" {
  type = map(string)
}

variable "cidrs_private_subnet" {
  type = map(string)
}

variable "nat_connectivity_type" {
  description = "Connectivity type of the NAT gateway"
  type        = string
  default     = "public"
}

variable "availability_mode" {
  type    = string
  default = "regional"
}