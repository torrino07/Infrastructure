variable "key_name" {
  description = "Name for the AWS key pair in the development environment"
  type        = string
}

variable "private_key_pem" {
  description = "The generated RSA private key for development."
  sensitive   = true
}