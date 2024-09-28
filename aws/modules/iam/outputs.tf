output "s3_profile" {
  description = "The name of the IAM instance profile for S3 access"
  value       = aws_iam_instance_profile.s3_profile.name
}






