resource "aws_lambda_function" "this" {
  function_name = var.name
  handler       = var.handler
  runtime       = var.runtime
  role          = var.iam_role

  vpc_config {
    subnet_ids         = [var.subnet_id]
    security_group_ids = [var.security_group_id]
  }

  environment {
    variables = {
      ENVIRONMENT = var.environment
    }
  }

  tags = {
    Name = "${var.environment}-${var.name}-lambda"
  }
}