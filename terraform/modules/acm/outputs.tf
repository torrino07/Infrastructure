output "server_certificate" {
  value = aws_acm_certificate.server_vpn_cert
}

output "client_certificate" {
  value = aws_acm_certificate.client_vpn_cert
}