resource "aws_vpc_endpoint" "this" {
  vpc_id            = var.vpc_id
  service_name      = var.service_name
  vpc_endpoint_type = var.vpc_endpoint_type

  private_dns_enabled = var.vpc_endpoint_type == "Interface" ? true : false
  security_group_ids  = var.vpc_endpoint_type == "Interface" ? [var.sg_private_id] : null
  subnet_ids          = var.vpc_endpoint_type == "Interface" ? var.subnet_ids : null
  route_table_ids     = var.vpc_endpoint_type == "Gateway" ? [var.route_table_id] : null

  tags = {
    Name = "${var.environment}-${var.name}"
  }
}