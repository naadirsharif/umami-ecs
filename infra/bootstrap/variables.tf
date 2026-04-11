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

variable "ecr_repo_name" {
    description = "ECR Repo name"
    type    = string
}

#################################################################

# OIDC

variable "oidc_iam_name" {
  default = "github-actions-role"
}

variable "github_repo" {
    description = "github repository in the format 'owner/repo' that is allowed to assume iam role via GitHub Actions OIDC"
}

#################################################################

# S3

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  default     = "umami-tf-state"
}

#################################################################

# DynamoDB

variable "dynamo_db_name" {
  description  = "Name of DynamoDB Table"
  default      = "tf-lock"
}
