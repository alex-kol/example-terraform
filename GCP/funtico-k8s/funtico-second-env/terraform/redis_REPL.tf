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
  replica_count      = var.redis_replica # Read replicas are only supported on instance sizes 5GB and above
  read_replicas_mode = "READ_REPLICAS_ENABLED"

  depends_on = [google_service_networking_connection.private_vpc_connection]
}
