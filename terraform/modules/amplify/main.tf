resource "aws_amplify_app" "this" {
  name         = var.name
  repository   = var.repository_url
  platform     = "WEB"
  access_token = var.github_token

  environment_variables = {
    _LIVE_UPDATES = "true"
  }

  enable_branch_auto_build = false
}

resource "aws_amplify_domain_association" "this" {
  app_id      = aws_amplify_app.this.id
  domain_name = var.domain_name

  sub_domain {
    branch_name = var.branch_name
    prefix      = var.subdomain_prefix
  }
}