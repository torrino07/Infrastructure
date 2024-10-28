output "sg_ids" {
  value = [for sg in aws_security_group.this : sg.id]
}