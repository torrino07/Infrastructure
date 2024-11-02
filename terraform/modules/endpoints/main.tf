resource "aws_vpc_endpoint" "this" {
  for_each          = { for idx, endpoint in var.vpc_endpoints : idx => endpoint }
  vpc_id            = var.vpc_id
  service_name      = each.value.service_name
  vpc_endpoint_type = each.value.vpc_endpoint_type

  security_group_ids  = each.value.vpc_endpoint_type == "Interface" ? each.value.security_group_ids : null
  subnet_ids          = each.value.vpc_endpoint_type == "Interface" ? each.value.subnet_ids : null
  route_table_ids     = each.value.vpc_endpoint_type == "Gateway" ? each.value.route_table_ids : null
  private_dns_enabled = each.value.vpc_endpoint_type == "Interface" ? lookup(each.value, "private_dns_enabled", true) : null
  ip_address_type     = each.value.vpc_endpoint_type == "Interface" ? lookup(each.value, "ip_address_type", "ipv4") : null

  tags = {
    Name = "${var.proj}-${each.value.tag}"
  }
}
