/*
resource "google_project_service" "project" {
  for_each = var.project_service_apis
  project  = var.gcp_project_id
  service  = each.value.service

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = each.value.disable_dependent_services
}
*/
