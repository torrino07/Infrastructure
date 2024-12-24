resource "aws_route_table" "this" {
  for_each = var.subnet_ids
  vpc_id   = var.vpc_id

  route {
    cidr_block = var.cidr_block
    gateway_id = var.gateway_id
    nat_gateway_id = null
  }
  tags = {
    Name = "${each.key}-rt"
  }
}

resource "aws_route_table_association" "this" {
  for_each       = var.subnet_ids
  subnet_id      = each.value
  route_table_id = aws_route_table.this[each.key].id
}
