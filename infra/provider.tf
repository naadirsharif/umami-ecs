terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5"
    }
  }

  # Configure backend and state locking
  backend "s3" {
    bucket         = "umami-terraform-state-530193444530-eu-central-1-an"   
    key            = "terraform.tfstate"       
    region         = "eu-central-1"           
    dynamodb_table = "terraform-state-lock"   
    encrypt        = true                      
  }
}

# Configure AWS Provider
provider "aws" {
  region = "eu-central-1"
}

# Configure Cloudflare Provider
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
