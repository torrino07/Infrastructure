resource "aws_security_group" "this" {
  for_each = { for sg in var.security_groups : "${var.proj}-${var.environment}-${sg.name}-sg" => sg }

  name   = each.value.name
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = each.value.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = each.value.egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    Name    = "${var.proj}-${var.environment}-${each.value.name}-sg"
    Project = var.proj
  }
}
