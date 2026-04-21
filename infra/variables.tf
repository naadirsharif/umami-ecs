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
  type = string
}

#################################################################

# VPC Variables 

variable "availability_zones" {
  description = "availability zones 1a-1c"
  type        = list(string)
  default = [
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
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24"
  ]
}

variable "cidrs_private_subnet" {
  description = "CIDR blocks of private subnets"
  type        = list(string)
  default = [
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24"
  ]
}

#################################################################

# ALB variables

variable "alb_name" {
  description = "name of main ALB"
  type        = string
  default     = "main-alb-tf"
}

variable "alb_type" {
  description = "Type of ALB"
  type        = string
  default     = "application"
}

variable "target_group" {
  description = "Name of Target Group"
  type        = string
  default     = "ecs-tg"
}

variable "tg_port" {
  description = "port on which container listens"
  type        = number
  default     = 3000
}

variable "health_path" {
  description = "The http path the alb uses to check if container is healthy"
  type        = string
}

variable "ssl_policy" {
  description = "Policy of SSL"
  type        = string
  default     = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

# ALB SG
variable "sg_name_alb" {
  description = "name of the security group of the alb"
  type        = string
  default     = "alb_sg"
}

variable "alb_sg_description" {
  description = "description for the security group of the alb"
  type        = string
  default     = "Allow HTTP/HTTPS traffic"
}

#################################################################

# ECS variables

variable "cluster_name" {
  type        = string
  description = "name of ecs cluster"
  default     = "umami-cluster"
}

variable "app_image" {
  type = string
}

variable "db_string" {
  description = "connection string of databse"
  sensitive   = true
}

variable "desired_count" {
  type        = number
  description = "Desired number of ECS tasks for service"
}

# ECS SG
variable "sg_name_ecs" {
  description = "name of the security group for ecs"
  type        = string
  default     = "ecs_sg"
}

variable "ecs_sg_description" {
  description = "description for the security group of ecs"
  type        = string
  default     = "Allow only from ALB"
}

variable "container_port" {
  description = "internal port of container"
  type        = number
}

variable "container_cpu" {
  type = number
}

variable "container_memory" {
  type = number
}

#################################################################

# ACM variables

variable "domain_name" {
  description = "name of domain"
  type        = string
}

variable "acm_validation_method" {
  description = "validation method of ACM"
  type        = string
}

#################################################################

# IAM Variables

variable "ecs_iam_name" {
  type    = string
  default = "ecs_role"
}

#################################################################

# Cloudflare

variable "cloudflare_api_token" {
  sensitive = true
}

variable "zone_id_cloudflare" {
  type = string
}

variable "subdomain_name" {
  type = string
}
