output "server_certificate_arn" {
  value = aws_acm_certificate.this.arn
}

output "ca_certificate_body" {
  value = aws_acm_certificate.this.certificate_body
}