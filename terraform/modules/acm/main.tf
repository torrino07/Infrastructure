resource "aws_acm_certificate" "this" {
  private_key       = var.private_key
  certificate_body  = var.private_body
  certificate_chain = var.private_chain
  domain_name       = var.domain_name
}