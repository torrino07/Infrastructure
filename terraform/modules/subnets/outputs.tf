output "ids" {
  value = { for subnet in aws_subnet.this : subnet.tags["Name"] => subnet.id }
}
