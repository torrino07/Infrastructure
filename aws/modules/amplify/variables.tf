variable "region" {
  description = "The AWS region to deploy resources"
  type        = string
}

variable "name" {
  description = "The name of the Amplify app"
  type        = string
}

variable "repository_url" {
  description = "GitHub repository URL for the Amplify app"
  type        = string
}

variable "github_token" {
  description = "GitHub access token for AWS Amplify to use"
  type        = string
}

variable "domain_name" {
  description = "Custom domain name for the Amplify app"
  type        = string
}

variable "branch_name" {
  description = "The branch name that should be associated with the domain"
  type        = string
}

variable "subdomain_prefix" {
  description = "The subdomain prefix (e.g., www)"
  type        = string
}