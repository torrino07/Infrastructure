variable "proj" {
  type = string
}

variable "environment" {
  type = string
}

variable "repositories" {
  type = list(object({
    name                 = string
    scan_on_push         = bool
    image_tag_mutability = string
  }))
}
