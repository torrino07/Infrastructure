resource "aws_iam_role" "this" {
  name = "${var.environment}-${var.role_name}"
  assume_role_policy = file("${var.policy_path}")
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = var.policy_arn
}