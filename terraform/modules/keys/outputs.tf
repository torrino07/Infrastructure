output "key_pair_name" {
  value       = aws_key_pair.this.key_name
  description = "The name of the generated AWS key pair for development."
}

output "private_key_pem" {
  value       = tls_private_key.this.private_key_pem
  description = "The generated RSA private key for development."
  sensitive   = true
}