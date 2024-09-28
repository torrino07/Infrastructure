resource "tls_private_key" "private_key_dev" {
  algorithm = var.key_algorithm
  rsa_bits  = var.key_rsa_bits
}

resource "aws_key_pair" "generated_key_dev" {
  key_name   = var.key_name_dev
  public_key = tls_private_key.private_key_dev.public_key_openssh
}

resource "local_file" "private_key_dev" {
  content  = tls_private_key.private_key_dev.private_key_pem
  filename = "${path.module}/../../dev.pem"
}
