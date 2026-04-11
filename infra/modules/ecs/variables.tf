variable "tags" {
  type = map(string)
}

variable "region" {
  type = string
}

variable "cluster_name" {
    type = string
    description = "name of ecs cluster"
}

variable "db_string" {
    description = "connection string of databse"
    type        = string
    sensitive   = true
}

variable "sg_name_ecs" {
    description = "name of the security group for ecs"
    type        = string
    default     = "ecs_sg"
}

variable "vpc_id" {
    type = string
}

variable "private_subnet_ids" {
    type = list(string)
}

variable "alb_sg_id" {
    type = string
}

variable "ecs_sg_description" {
    description = "description for the security group of ecs"
    type        = string
    default     = "Allow only from ALB"
}

variable "container_port" {
    description = "internal port of container"
    type        = number
    default     = 3000
}

variable "tg_arn" {
    description = "arn of target group"
    type        = string
}

variable "app_image" {
    description = "docker image"
    type = string
}


# IAM 
variable "ecs_iam_name" {
    type = string
    default = "ecs_role"
}

