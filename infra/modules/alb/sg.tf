## ALB Security Group
resource "aws_security_group" "alb_sg" {
  name        = var.sg_name_alb
  description = var.alb_sg_description
  vpc_id      = var.vpc_id

    ingress {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
    cidr_blocks = ["0.0.0.0/0"]
  } # -> Allow HTTP

  ingress {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
    cidr_blocks = ["0.0.0.0/0"]
  } # -> Allow HTTPS

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  tags = var.tags
}
