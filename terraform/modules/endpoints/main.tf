resource "aws_vpc_endpoint" "this" {
  count               = length(var.vpc_endpoints)
  vpc_id              = var.vpc_id
  
  service_name        = var.vpc_endpoints[count.index]
  vpc_endpoint_type   = can(regex("s3$", var.vpc_endpoints[count.index])) ? "Gateway" : "Interface"
  security_group_ids = can(regex("s3$", var.vpc_endpoints[count.index])) ? null : var.sg_ids
  private_dns_enabled = can(regex("s3$", var.vpc_endpoints[count.index])) ? null : true
  subnet_ids      = can(regex("s3$", var.vpc_endpoints[count.index])) ? null : var.subnet_ids
  route_table_ids = can(regex("s3$", var.vpc_endpoints[count.index])) ? var.rt_ids : null

   tags = {
    Name = "${var.proj}-${var.vpc_endpoints_tags[count.index]}"
  }
}
