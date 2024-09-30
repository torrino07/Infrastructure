variable "key_algorithm" {
  description = "Algorithm to use for the private key"
  default     = "RSA"
  type        = string
}

variable "key_rsa_bits" {
  description = "Number of bits for the RSA key"
  default     = 4096
  type        = number
}

variable "key_name" {
  description = "Name for the AWS key pair in the development environment"
  type        = string
  default     = "dev"
}
