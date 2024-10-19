output "policy_arn" {
  description = "The ARN of the iam profile"
  value       = aws_iam_role.this.arn
}

output "iam_profile_name" {
  description = "The name of iam profile"
  value       = aws_iam_role.this.name
}