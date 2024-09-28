output "subnet_id" {
  value       = aws_subnet.private_subnet.id
  description = "The ID of the subnet"
}