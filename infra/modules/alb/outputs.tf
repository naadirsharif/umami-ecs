output "alb_dns_name" {
    description = "DNS name of the ALB"
    value       = aws_lb.main.dns_name
}

output "ecs_target_group_arn" {
    description = "ARN of the ECS target group"
    value       = aws_lb_target_group.ecs_tg.arn
}

output "http_listener_arn" {
    description = "ARN of the http listener"
    value       = aws_lb_listener.http.arn
}

output "https_listener_arn" {
    description = "ARN of the https listener"
    value       = aws_lb_listener.https.arn
}


output "alb_sg_id" {
    value = aws_security_group.alb_sg.id
}