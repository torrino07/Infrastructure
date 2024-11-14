output "ids" {
  value = { for endpoint in aws_vpc_endpoint.this : endpoint.tags["Name"] => endpoint.id }
}
