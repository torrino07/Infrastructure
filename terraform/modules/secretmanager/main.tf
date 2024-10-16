resource "aws_secretsmanager_secret" "this" {
  name        = var.key_name
  description = "Private key for EC2 instance ${var.key_name}"
  force_overwrite_replica_secret = true
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = var.private_key_pem
}