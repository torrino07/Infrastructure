variable "private_key_pem_dev" {
  description = "The PEM encoded private key data for the EC2 instance"
  type        = string
  sensitive   = true
}

variable "private_key_pem_test" {
  description = "The PEM encoded private key data for the EC2 instance"
  type        = string
  sensitive   = true
}

variable "private_key_pem_prod" {
  description = "The PEM encoded private key data for the EC2 instance"
  type        = string
  sensitive   = true
}

variable "key_name_dev" {
  description = "Name for the AWS key pair in the development environment"
  type        = string
}

variable "key_name_test" {
  description = "Name for the AWS key pair in the test environment"
  type        = string
}

variable "key_name_prod" {
  description = "Name for the AWS key pair in the prod environment"
  type        = string
}

variable "dev_public_subnet" {
  description = "The public subnet for the EC2 instance dev"
  type        = any
}

variable "test_public_subnet" {
  description = "The public subnet for the EC2 instance test"
  type        = any
}

variable "prod_public_subnet" {
  description = "The public subnet for the EC2 instance prod"
  type        = any
}

variable "sg_public" {
  description = "The public security group for the EC2 instance"
  type        = any
}

variable "sg_private" {
  description = "The private security group for the EC2 instance"
  type        = any
}

variable "s3_profile" {
  description = "The IAM instance profile for S3 access"
  type        = any
}


variable "db_endpoint_dev" {
  description = "Endpoint for the database"
  type        = string
}

variable "db_endpoint_test" {
  description = "Endpoint for the database"
  type        = string
}

variable "db_endpoint_prod" {
  description = "Endpoint for the database"
  type        = string
}

variable "username_dev" {
  description = "The username for the development PostgreSQL database"
  type        = string
}

variable "password_dev" {
  description = "The password for the development PostgreSQL database"
  type        = string
}

variable "username_test" {
  description = "The username for the development PostgreSQL database"
  type        = string
}

variable "password_test" {
  description = "The password for the development PostgreSQL database"
  type        = string
}

variable "username_prod" {
  description = "The username for the development PostgreSQL database"
  type        = string
}

variable "password_prod" {
  description = "The password for the development PostgreSQL database"
  type        = string
}
