resource "tls_private_key" "this" {
  algorithm = var.key_algorithm
  rsa_bits  = var.key_rsa_bits
}

resource "aws_key_pair" "this" {
  key_name   = var.key_name
  public_key = tls_private_key.this.public_key_openssh
}