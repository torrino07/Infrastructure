output "server_certificate_arn" {
  value = aws_acm_certificate.this.arn
}

output "certificate_authority_arn" {
  value = aws_acm_certificate.this.certificate_authority_arn
}