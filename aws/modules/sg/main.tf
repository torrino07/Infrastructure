resource "aws_security_group" "elastic_beanstalk_private_sg" {
  name        = "elastic-beanstalk-sg"
  description = "Allow VPN access only"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.environment}-elastic-beanstalk-sg"
  }
}