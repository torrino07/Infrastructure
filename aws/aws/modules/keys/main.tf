resource "tls_private_key" "private_key_dev" {
  algorithm = var.key_algorithm
  rsa_bits  = var.key_rsa_bits
}

resource "tls_private_key" "private_key_test" {
  algorithm = var.key_algorithm
  rsa_bits  = var.key_rsa_bits
}

resource "tls_private_key" "private_key_prod" {
  algorithm = var.key_algorithm
  rsa_bits  = var.key_rsa_bits
}

resource "aws_key_pair" "generated_key_dev" {
  key_name   = var.key_name_dev
  public_key = tls_private_key.private_key_dev.public_key_openssh
}

resource "aws_key_pair" "generated_key_test" {
  key_name   = var.key_name_test
  public_key = tls_private_key.private_key_test.public_key_openssh
}

resource "aws_key_pair" "generated_key_prod" {
  key_name   = var.key_name_prod
  public_key = tls_private_key.private_key_prod.public_key_openssh
}

resource "local_file" "private_key_dev" {
  content  = tls_private_key.private_key_dev.private_key_pem
  filename = "${path.module}/../../dev.pem"
}

resource "local_file" "private_key_test" {
  content  = tls_private_key.private_key_test.private_key_pem
  filename = "${path.module}/../../test.pem"
}

resource "local_file" "private_key_prod" {
  content  = tls_private_key.private_key_prod.private_key_pem
  filename = "${path.module}/../../prod.pem"
}
