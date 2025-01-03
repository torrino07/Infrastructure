resource "aws_acm_certificate" "this" {
  private_key       = file("../certs/server.key")
  certificate_body  = file("../certs/server.crt")
  certificate_chain = file("../certs/ca.crt")

  tags = {
    Environment = "${var.environment}"
    Name        = "${var.proj}-${var.environment}-acm"
  }
}
