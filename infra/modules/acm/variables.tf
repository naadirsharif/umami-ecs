variable "tags" {
  type = map(string)
}

variable "subdomain_name" {
  type = string
}

variable "domain_name" {
  description = "name of domain"
  type        = string
}

variable "acm_validation_method" {
  description = "validation method of ACM"
  type        = string
}

variable "zone_id" {
  type = string
}