output "Kubernetes_Cluster_Name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}

output "Load_Balancer_IP" {
  value       = google_compute_global_address.ip-lb.address
  description = "Load Balancer IP"
}

output "Redis_IP" {
  value = "${google_redis_instance.redis.host}:${google_redis_instance.redis.port}"
  description = "The IP address of the instance."
}

output "Database_Master_Public_IP" {
  value = tomap({
    for k, inst in google_sql_database_instance.master : k => inst.public_ip_address
  })
  description = "The IP address of the instance."
}

output "Database_Master_Private_IP" {
  value = tomap({
    for k, inst in google_sql_database_instance.master : k => inst.private_ip_address
  })
  description = "The IP address of the instance."
}

output "Database_Slave_Private_IP" {
  value = tomap({
    for k, inst in google_sql_database_instance.slave : k => inst.private_ip_address
  })
  description = "The IP address of the instance."
}

# output "CDN_Public_IP" {
#   value       = google_compute_global_address.cdn_public_address.address
#   description = "CDN Bucket"
# }
