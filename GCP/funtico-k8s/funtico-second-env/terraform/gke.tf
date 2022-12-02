# GKE cluster
resource "google_container_cluster" "primary" {
  name                      = var.cluster_name
  location                  = var.region
  min_master_version        = var.gke_cluster_version

  # We can't create a cluster with no node pool defined, but we want to only use separately managed node pools. So we create the smallest possible default node pool and immediately delete it.
  remove_default_node_pool  = true
  initial_node_count        = 1

  network    = google_compute_network.vpc-network.id
  subnetwork = google_compute_subnetwork.vpc-sub-network.id

  # vertical_pod_autoscaling {
  #   enabled = true
  # }

  # cluster_autoscaling {
  #   enabled = true
  #   resource_limits {
  #     resource_type = "cpu"
  #     minimum       = 4
  #     maximum       = 28
  #   }
  #   resource_limits {
  #     resource_type = "memory"
  #     minimum       = 8
  #     maximum       = 96
  #   }
  # }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.k8s_master_ipv4_cidr_block
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "sub-network-pods"
    services_secondary_range_name = "sub-network-services"
  }

  lifecycle {
    ignore_changes = [
      maintenance_policy,
    ]
  }

  timeouts {
    create = "30m"
  }

}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${google_container_cluster.primary.name}-node-pool"
  cluster    = google_container_cluster.primary.name
  location   = var.region
  node_count = var.gke_num_node_pool

  autoscaling {
    max_node_count = 5
    min_node_count = 1
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      env = var.project_id
    }

    preemptible  = true
    machine_type = var.gke_machine_type
    disk_size_gb = var.disk_size
    disk_type    = "pd-ssd"
    tags         = ["gke-node", var.cluster_name]

    metadata = {
      disable-legacy-endpoints = "true"
    }

  }

  lifecycle {
    ignore_changes = [
      autoscaling
    ]
  }

  timeouts {
    create = "30m"
  }

}

resource "google_compute_ssl_policy" "production-ssl-policy" {
  name            = "ssl-policy"
  profile         = "MODERN"
  min_tls_version = "TLS_1_2"
}
