data "aws_acm_certificate" "this" {
  domain = var.domain_name
  statuses = ["ISSUED"]
}