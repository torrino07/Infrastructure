resource "aws_route_table" "this" {
  count  = length(var.subnet_ids)
  vpc_id = var.vpc_id

  route {
    cidr_block = var.cidr_block
    gateway_id = var.gateway_id
  }
  tags = {
    Name = "${var.proj}-rt-${var.tags[count.index]}"
  }
}

resource "aws_route_table_association" "this" {
  count          = length(aws_route_table.this[*].id)
  subnet_id      = var.subnet_ids[count.index]
  route_table_id = aws_route_table.this[count.index].id
}