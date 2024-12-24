resource "aws_eip" "this" {
  vpc    = true

  tags = {
    Name        = "${var.proj}-${var.environment}-nat-gateway"
    Environment = var.proj
  }
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = var.subnet_id

  tags = {
    Name        = "${var.proj}-${var.environment}-nat-gateway"
    Environment = var.proj
  }
}