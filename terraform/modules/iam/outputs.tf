
output "ss_profile_name" {
  value       = aws_iam_instance_profile.this.name
  description = "profile"
}

output "arn" {
  description = "The ARN of the iam profile"
  value       = aws_iam_instance_profile.this.arn
}