resource "aws_vpc_endpoint" "this" {
  vpc_id              = var.vpc_id
  service_name        = var.service_name
  vpc_endpoint_type   = var.vpc_endpoint_type

  private_dns_enabled = true
  security_group_ids  = [var.sg_private_id]
  subnet_ids          = [var.subnet_id]
   tags = {
    "Name" = "${var.environment}-${var.name}"
  }
}