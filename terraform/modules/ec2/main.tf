resource "aws_instance" "this" {
  ami                    = var.ami
  instance_type          = var.instance_type
  subnet_id              = var.private_subnet_id
  vpc_security_group_ids = [var.sg_private]
  key_name               = var.key_name
  iam_instance_profile   = var.iam_instance_profile

  tags = {
    Name        = "${var.environment}-trading-server"
    Environment = var.environment
  }
}
