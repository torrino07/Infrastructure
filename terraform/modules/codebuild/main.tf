data "aws_iam_role" "codebuild_project_role" {
  name = "${var.proj}-${var.environment}-${var.role_arn_name}-iam-role"
}

resource "aws_codebuild_project" "this" {
  name         = "${var.proj}-${var.environment}-gh-actions"
  service_role = data.aws_iam_role.codebuild_project_role.arn

  source {
    type     = "GITHUB"
    location = "https://github.com/torrino07/cicd-pipeline"
  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0"
    type         = "LINUX_CONTAINER"
  }

  vpc_config {
    vpc_id = var.vpc_id
    subnets = var.subnet_ids
    security_group_ids = var.sg_ids
  }
}

resource "aws_codebuild_source_credential" "example" {
  auth_type   = "PERSONAL_ACCESS_TOKEN"
  server_type = "GITHUB"
  token       = "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"
}

resource "aws_codebuild_webhook" "this" {
  project_name = aws_codebuild_project.this.name

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "WORKFLOW_JOB_QUEUED"
    
    }
  }
}
