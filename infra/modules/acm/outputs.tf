output "domain_name" {
  value = aws_acm_certificate.cert.domain_name
}

output "certificate_arn" {
  value = aws_acm_certificate.cert.arn
}

output "certificate_validation_arn" {
  value = aws_acm_certificate_validation.cert_validation.certificate_arn
}