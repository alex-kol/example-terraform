# Storage
# resource "google_storage_bucket" "storage" {
#   project       = var.project_id
#   name          = "${var.project_id}-${var.env_name}-storage"
#   force_destroy = false
#   location      = "EU"
# }

resource "google_container_registry" "registry" {
  project  = var.project_id
  location = "EU"
}
