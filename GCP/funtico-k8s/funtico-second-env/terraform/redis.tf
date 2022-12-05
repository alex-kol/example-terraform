resource "google_redis_instance" "redis" {
  name           = "${var.project_id}-redis"
  tier           = "STANDARD_HA"
  memory_size_gb = var.redis_ram_size_gb

  location_id             = "${var.region}-a"
  alternative_location_id = "${var.region}-b"

  authorized_network = google_compute_network.vpc-network.id
  connect_mode       = "PRIVATE_SERVICE_ACCESS"

  redis_version     = "REDIS_5_0"
  display_name      = "Arcadia HA Redis"

  depends_on = [google_service_networking_connection.private_vpc_connection]
}
