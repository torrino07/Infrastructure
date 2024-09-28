output "internet_gateway_id" {
  value       = aws_internet_gateway.services_network_gateway.id
  description = "The ID of the created Internet Gateway"
}
