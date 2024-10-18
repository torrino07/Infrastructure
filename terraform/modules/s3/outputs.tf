output "cert_content" {
  value = data.aws_s3_object.this.body
}
