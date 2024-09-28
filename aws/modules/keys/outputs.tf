output "private_key_dev" {
  value       = tls_private_key.private_key_dev.private_key_pem
  description = "The generated RSA private key for development."
  sensitive   = true
}

output "key_pair_name_dev" {
  value       = aws_key_pair.generated_key_dev.key_name
  description = "The name of the generated AWS key pair for development."
}

output "private_key_test" {
  value       = tls_private_key.private_key_test.private_key_pem
  description = "The generated RSA private key for test."
  sensitive   = true
}

output "key_pair_name_test" {
  value       = aws_key_pair.generated_key_test.key_name
  description = "The name of the generated AWS key pair for test."
}

output "private_key_prod" {
  value       = tls_private_key.private_key_prod.private_key_pem
  description = "The generated RSA private key for production."
  sensitive   = true
}

output "key_pair_name_prod" {
  value       = aws_key_pair.generated_key_prod.key_name
  description = "The name of the generated AWS key pair for production."
}
