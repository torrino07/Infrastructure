resource "aws_acm_certificate" "this" {
  private_key       = file("${var.private_key}")
  certificate_body  = file("${var.private_body}")
  certificate_chain = file("${var.private_chain}")
}