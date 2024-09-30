
output "dev_postgresql_endpoint" {
  value = aws_db_instance.dev_postgresql_instance.endpoint
}

output "test_postgresql_endpoint" {
  value = aws_db_instance.test_postgresql_instance.endpoint
}

output "prod_postgresql_endpoint" {
  value = aws_db_instance.prod_postgresql_instance.endpoint
}

output "db_username_dev" {
  value     = aws_db_instance.dev_postgresql_instance.username
  sensitive = true
}

output "db_password_dev" {
  value     = aws_db_instance.dev_postgresql_instance.password
  sensitive = true
}

output "db_username_test" {
  value     = aws_db_instance.test_postgresql_instance.username
  sensitive = true
}

output "db_password_test" {
  value     = aws_db_instance.test_postgresql_instance.password
  sensitive = true
}

output "db_username_prod" {
  value     = aws_db_instance.prod_postgresql_instance.username
  sensitive = true
}

output "db_password_prod" {
  value     = aws_db_instance.prod_postgresql_instance.password
  sensitive = true
}
