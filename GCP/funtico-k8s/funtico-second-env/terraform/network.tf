# VPC
resource "google_compute_network" "vpc-network" {
  project                 = var.project_id
  name                    = "${var.project_id}-net"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc-subnet" {
  project                  = var.project_id
  name                     = "${var.project_id}-subnet"
  ip_cidr_range            = var.vpc_range
  region                   = var.region
  network                  = google_compute_network.vpc-network.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "subnet-pods"
    ip_cidr_range = var.vpc_subnet_range_1
  }

  secondary_ip_range {
    range_name    = "subnet-services"
    ip_cidr_range = var.vpc_subnet_range_2
  }

}

# Private IP address
resource "google_compute_global_address" "private_ip_address" {
  project       = var.project_id
  name          = "${var.project_id}-private-ip"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc-network.id
}

# Private connection
resource "google_service_networking_connection" "private_vpc_connection" {
  network                 = google_compute_network.vpc-network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

# SSH
resource "google_compute_firewall" "ssh-access" {
  project = var.project_id
  name    = "${var.project_id}-ssh-access"
  network = google_compute_network.vpc-network.id

  allow {
    protocol = "tcp"
    ports    = ["22", "3306", "5672", "15672", "6379"]
  }

  source_ranges = ["62.80.191.137/32", "18.195.80.139/32", "10.0.0.0/8"]
}

# Create Cloud NAT to avoid External IP on VM instances, but provide connection to exteranal resources
resource "google_compute_router" "router" {
  project = var.project_id
  name    = "${var.project_id}-router"
  region  = google_compute_subnetwork.vpc-subnet.region
  network = google_compute_network.vpc-network.id

  lifecycle {
    ignore_changes = [
      bgp
    ]
  }

}

# Static IP
resource "google_compute_global_address" "ip-lb" {
  project = var.project_id
  name    = "${var.project_id}-${var.env_name}-static-ip"
}

# resource "google_compute_address" "static-nat" {
#   project = var.project_id
#   name    = "${var.project_id}-static-nat-${count.index}"
#   region  = google_compute_subnetwork.vpc-subnet.region
#   count   = 2
# }

resource "google_compute_router_nat" "nat" {
  project                             = var.project_id
  name                                = "${var.project_id}-nat"
  router                              = google_compute_router.router.name
  region                              = google_compute_router.router.region
  nat_ip_allocate_option              = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat  = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
  
}

# Serverless VPC access
resource "google_vpc_access_connector" "access_vpc" {
  project        = var.project_id
  name           = "${var.project_id}-vpc"
  region         = var.region
  ip_cidr_range  = var.vpc_serverless_range
  network        = google_compute_network.vpc-network.name
  min_throughput = 200
  max_throughput = 300
}

resource "google_compute_project_default_network_tier" "default" {
  project      = var.project_id
  network_tier = "PREMIUM"
}
