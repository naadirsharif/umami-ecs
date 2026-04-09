# ACM module: creates an SSL certificate for a given domain

## Certificate
resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = var.acm_validation_method

  tags = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

# ACM Validation

# Cloudflare as DNS
terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

## Validation Record
resource "cloudflare_dns_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => dvo
  }

  zone_id = var.zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  content = each.value.resource_record_value
  ttl     = 1
  proxied = false
}

## Validate!
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn         = aws_acm_certificate.cert.arn
   validation_record_fqdns = [
    for record in cloudflare_dns_record.cert_validation :
    "${record.name}.${var.domain_name}"
   ]
}