variable "proj" {
  type = string
}

variable "roles" {
  type = list(object({
    name        = string
    effect      = string
    type        = string
    identifiers = list(string)
    actions     = list(string)
    policy_arns = list(string)
  }))
}