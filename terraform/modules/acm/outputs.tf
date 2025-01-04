output "server_certificate" {
  value = aws_acm_certificate.server_vpn_cert.arn
}

output "client_certificate" {
  value = aws_acm_certificate.client_vpn_cert.arn
}