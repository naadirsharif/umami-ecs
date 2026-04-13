# ALB module: creates load balancer, listeners, target group and security group

## ALB
resource "aws_lb" "main" {
  name                       = var.alb_name
  internal                   = false
  load_balancer_type         = var.alb_type
  security_groups            = [aws_security_group.alb_sg.id]
  subnets                    = var.public_subnets
  enable_deletion_protection = true

  tags = var.tags
}

## Target group
resource "aws_lb_target_group" "ecs_tg" {
  name        = var.target_group
  port        = var.tg_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = 3
    interval            = 30
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    path                = var.health_path
  }
  tags = var.tags
}

## ALB Listener 
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  tags = var.tags
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.main.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn
  }
  tags = var.tags
}

