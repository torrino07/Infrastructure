variable "environment" {
  description = "The environment (dev, prod, test)"
  type        = string
}

variable "mutable" {
  description = "Mutable tag"
  type        = string
}

variable "name"{
    description = "Name of the Registry"
    type        = string
}