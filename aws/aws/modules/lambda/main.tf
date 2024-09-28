resource "aws_security_group" "elastic_beanstalk_sg" {
  name        = "${var.environment}-eb-sg"
  description = "Security group for Elastic Beanstalk in private subnet"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block]
  }

  tags = {
    Name        = "${var.environment}-eb-sg"
    Environment = var.environment
  }
}