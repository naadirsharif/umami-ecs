#################################################################

# General Variables

variable "tags" {
  type = map(string)
  default = {
    Project     = "umami"
    Environment = "dev"
  }
}

variable "region" {
  description = "AWS Region"
  type = string
}

#################################################################

# ECR

variable "ecr_name" {
    description = "ECR Repo name"
    type    = string
}