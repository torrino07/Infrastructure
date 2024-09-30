output "ecr_repository_url" {
  value = aws_ecr_repository.this.repository_url
  description = "The ECR repository URL to push the FastAPI image"
}