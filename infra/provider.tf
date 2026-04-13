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
    bucket         = "umami-tf-state-bucket"
    key            = "terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "tf-lock"
    encrypt        = true
  }
}

# Configure AWS Provider
provider "aws" {
  region = var.region
}

# Configure Cloudflare Provider
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
