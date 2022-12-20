# resource "google_storage_bucket" "cdn_bucket" {
#   project                     = var.project_id
#   name                        = "${var.project_id}-${var.env_name}-${var.cdn_bucket}"
#   location                    = var.region
#   # force_destroy               = true
#   uniform_bucket_level_access = true
# }

# resource "google_storage_bucket_iam_member" "all_users_viewers" {
#   bucket = google_storage_bucket.cdn_bucket.name
#   role   = "roles/storage.legacyObjectReader"
#   member = "allUsers"
# }

# resource "google_compute_backend_bucket" "cdn_backend_bucket" {
#   project     = var.project_id
#   name        = "cdn-backend-bucket"
#   description = "Backend bucket for serving static content through CDN"
#   bucket_name = google_storage_bucket.cdn_bucket.name
#   enable_cdn  = true
# }

# resource "google_compute_global_address" "cdn_public_address" {
#   project      = var.project_id
#   name         = "${var.project_id}-cdn-public-ip"
#   ip_version   = "IPV4"
#   address_type = "EXTERNAL"
# }

# data "google_compute_ssl_certificate" "cdn_certificate" {
#   name = var.cert_name
# }

# # resource "google_compute_target_https_proxy" "cdn_https_proxy" {
# #   project          = var.project_id
# #   name             = "cdn-https-proxy"
# #   url_map          = google_compute_url_map.cdn_url_map.self_link
# #   ssl_certificates = [data.google_compute_ssl_certificate.cdn_certificate.self_link]
# # }

# # resource "google_compute_global_forwarding_rule" "cdn_global_forwarding_rule" {
# #   project    = var.project_id
# #   name       = "cdn-global-forwarding-https-rule"
# #   target     = google_compute_target_https_proxy.cdn_https_proxy.self_link
# #   ip_address = google_compute_global_address.cdn_public_address.address
# #   port_range = "443"
# # }

# resource "google_compute_url_map" "cdn_url_map" {
#   project         = var.project_id
#   name            = "cdn-url-map"
#   description     = "CDN URL map to cdn_backend_bucket"
#   default_service = google_compute_backend_bucket.cdn_backend_bucket.self_link
# }
