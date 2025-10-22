resource "aws_route_table" "this" {
  for_each = { for route in var.routes : route.name => route }
  vpc_id   = var.vpc_id
  tags = {
    Name = "${each.key}-rt"
  }
}

resource "aws_route" "private" {
  for_each       = { for route in var.routes : route.name => route if route.type == "private" && route.internet == true }
  route_table_id = aws_route_table.this[each.key].id

  destination_cidr_block = each.value.destination_cidr_block
  nat_gateway_id         = each.value.gateway_id
}

resource "aws_route" "public" {
  for_each       = { for route in var.routes : route.name => route if route.type == "public" && route.internet == true }
  route_table_id = aws_route_table.this[each.key].id

  destination_cidr_block = each.value.destination_cidr_block
  gateway_id             = each.value.gateway_id
}

resource "aws_route_table_association" "this" {
  for_each       = { for route in var.routes : route.name => route }
  subnet_id      = each.value.subnet_id
  route_table_id = aws_route_table.this[each.key].id
}
