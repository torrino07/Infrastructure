resource "aws_route" "this" {
  route_table_id         = var.aws_route_table_private_id
  destination_cidr_block = var.destination_cidr_block
  gateway_id             = var.aws_vpc_endpoint_id
}
