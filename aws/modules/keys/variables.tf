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
variable "key_name_dev" {
  description = "Name for the AWS key pair in the development environment"
  type        = string
  default     = "dev"
}

variable "key_name_test" {
  description = "Name for the AWS key pair in the test environment"
  default     = "test"
  type        = string
}

variable "key_name_prod" {
  description = "Name for the AWS key pair in the production environment"
  default     = "prod"
  type        = string
}
