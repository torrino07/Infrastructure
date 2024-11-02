output "ids" {
  # value = aws_route_table.this[*].id
  value = { for route_table in aws_route_table.this :  route_table.tags["Name"] =>  route_table.id }
}