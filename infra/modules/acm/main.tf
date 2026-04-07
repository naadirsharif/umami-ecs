# ACM module: creates an SSL certificate for a given domain
resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = var.acm_validation_method

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}