
locals {
  sanitized_tags_raw = {
    for k, v in var.tags :
    replace(lower(k), "/[^a-z0-9_-]/", "_") =>
    replace(lower(tostring(v)), "/[^a-z0-9_-]/", "-")
  }

  sanitized_tags = {
    for k, v in local.sanitized_tags_raw :
    (can(regex("^[a-z].*", k)) && length(k) > 0 ? k : "x_${k}") =>
    substr(v, 0, 63)
  }
}

resource "google_project_service" "this" {
  for_each = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
  ])
  project                    = google_project.this.project_id
  service                    = each.key
  disable_dependent_services = true
}