
resource "google_project" "this" {
  project_id      = var.project_id
  name            = "prj-${var.app}-${var.environment}-${var.region}"
  org_id          = var.org_id
  billing_account = var.billing_account

  labels = var.tags
}

resource "google_project_service" "this" {
  for_each                   = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
  ])
  project                    = google_project.this.project_id
  service                    = each.key
  disable_dependent_services = true
}