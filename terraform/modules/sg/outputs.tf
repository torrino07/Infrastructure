output "ids" {
  value = { for sg in aws_security_group.this : sg.tags["Name"] => sg.id }
}
