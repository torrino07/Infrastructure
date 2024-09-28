resource "aws_route_table" "private_route_table" {
  vpc_id = var.vpc_id

  tags = {
    Name        = "${var.environment}-private-route-table"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "private_subnet" {
  subnet_id      = var.subnet_id
  route_table_id = aws_route_table.private_route_table.id
}
