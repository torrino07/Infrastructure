resource "aws_iam_role" "this" {
  name = "${var.environment}-${var.name}-iam-role"
  assume_role_policy = file("${var.assume_role_policy_path}")
  }

resource "aws_iam_role_policy_attachment" "this" {
  for_each   = toset(var.policy_arns)
  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "this" {
  name = "${var.environment}-${var.name}-instance-profile"
  role = aws_iam_role.this.name
}