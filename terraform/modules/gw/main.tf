resource "aws_internet_gateway" "this" {
  vpc_id = var.vpc_id

  tags = {
    Name        = "${var.proj}-${var.environment}-igw"
    Environment = var.proj
  }
}
resource "aws_eip" "this" {
  domain = "vpc"

  tags = {
    Name        = "${var.proj}-${var.environment}-eip"
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

  depends_on = [aws_internet_gateway.this]
}
