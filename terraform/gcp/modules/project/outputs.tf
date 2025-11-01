output "project_computed_name" {
  value       = "prj-${var.app}-${var.environment}-${var.region}"
  description = "Computed project name from variables."
}