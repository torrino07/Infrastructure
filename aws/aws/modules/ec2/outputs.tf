output "dev_instance_public_ip" {
  description = "Public IP Address of the Development Trading Server"
  value       = aws_instance.trading_server_dev.public_ip
  sensitive   = true
}

output "test_instance_public_ip" {
  description = "Public IP Address of the Test Trading Server"
  value       = aws_instance.trading_server_test.public_ip
  sensitive   = true
}

output "prod_instance_public_ip" {
  description = "Public IP Address of the Production Trading Server"
  value       = aws_instance.trading_server_prod.public_ip
  sensitive   = true
}
