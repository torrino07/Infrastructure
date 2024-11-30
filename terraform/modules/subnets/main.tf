resource "aws_subnet" "this" {
  for_each                = { for subnet in var.subnets : "${var.proj}-${var.environment}-${subnet.client_name_type}-${subnet.route_type}-${subnet.az}-${subnet.number}" => subnet }
  vpc_id                  = var.vpc_id
  cidr_block              = each.value.cidr_block
  availability_zone       = "${var.region}-${each.value.az}"
  map_public_ip_on_launch = each.value.route_type == "private" ? false : true

  tags = {
    Name    = "${var.proj}-${var.environment}-${each.value.client_name_type}-${each.value.route_type}-${each.value.az}-${each.value.number}"
    Project = var.proj
  }
}
