output "project_id" {
  value       = google_project.this.project_id
  description = "The unique ID of the GCP project."
}

output "project_number" {
  value       = google_project.this.number
  description = "The numeric identifier of the GCP project."
}

output "project_name" {
  value       = google_project.this.name
  description = "The display name of the GCP project."
}

output "project_labels" {
  value       = google_project.this.labels
  description = "Labels applied to the GCP project."
}

output "project_computed_name" {
  value       = "prj-${var.app}-${var.environment}-${var.region}"
  description = "Computed project name from variables."
}

output "project" {
  value = {
    id     = google_project.this.project_id
    number = google_project.this.number
    name   = google_project.this.name
    labels = google_project.this.labels
  }
  description = "Selected properties of the GCP project."
}