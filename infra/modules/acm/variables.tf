variable "tags" {
  type = map(string)
}

# ACM variables
variable "domain_name" {  
    description = "name of domain"
    type        = string
}

variable "acm_validation_method" {
    description = "validation method of ACM"
    type        = string
}