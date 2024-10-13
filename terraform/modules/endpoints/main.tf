resource "aws_vpc_endpoint" "this" {
  vpc_id            = var.vpc_id
  service_name      = var.service_name
  vpc_endpoint_type = var.vpc_endpoint_type
  subnet_ids        = var.var.subnet_ids

  security_group_ids = [
    aws_security_group.vpc_sg.id
  ]

  private_dns_enabled = true
  tags = {
    Name = "${var.environment}-${var.name}-vpce"
  }
}