output "amplify_app_id" {
  value = aws_amplify_app.this.id
}

output "amplify_domain" {
  value = aws_amplify_domain_association.this.domain_name
}