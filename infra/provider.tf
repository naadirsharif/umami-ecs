terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure backend and state locking
backend "s3" {
    bucket         = "umami-terraform-state"   
    key            = "terraform.tfstate"       
    region         = "eu-central-1"           
    dynamodb_table = "terraform-state-lock"   
    encrypt        = true                      

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}
