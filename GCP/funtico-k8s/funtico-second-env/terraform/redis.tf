resource "google_redis_instance" "redis" {
  name           = "${var.project_id}-redis"
  tier           = "STANDARD_HA"

  location_id             = "${var.region}-a"
  alternative_location_id = "${var.region}-b"

  authorized_network = google_compute_network.vpc-network.id
  connect_mode       = "PRIVATE_SERVICE_ACCESS"

  display_name       = "Redis"
  redis_version      = var.redis_version
  memory_size_gb     = var.redis_ram_size_gb

  maintenance_policy {
    weekly_maintenance_window {
      day = "MONDAY"
      start_time {
        hours = 6
        minutes = 0
        seconds = 0
        nanos = 0
      }
    }
  }

  depends_on = [google_service_networking_connection.private_vpc_connection]
}
