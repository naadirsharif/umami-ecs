variable "tags" {
  type = map(string)
}

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

variable "vpc_id" {
    type = string
}

variable "cert_arn" {
    type = string
}

variable "public_subnets" {
    type = list(string)
}

# Security Group
variable "sg_name_alb" {
    description = "name of the security group of the alb"
    type        = string
}

variable "alb_sg_description" {
    description = "description for the security group of the alb"
    type        = string
}
