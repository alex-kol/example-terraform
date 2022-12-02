# VPC
resource "google_compute_network" "vpc-network" {
  name                    = "${var.project_id}-net"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "vpc-sub-network" {
  name                     = "${var.project_id}-net-subnetwork"
  ip_cidr_range            = var.vpc_range
  region                   = var.region
  network                  = google_compute_network.vpc-network.id
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "sub-network-pods"
    ip_cidr_range = var.vpc_subnetwork_range_1
  }

  secondary_ip_range {
    range_name    = "sub-network-services"
    ip_cidr_range = var.vpc_subnetwork_range_2
  }

}

# Private IP address
resource "google_compute_global_address" "private_ip_address" {
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
  name    = "${var.project_id}-ssh-access"
  project = var.project_id
  network = google_compute_network.vpc-network.id

  allow {
    protocol = "tcp"
    ports    = [22]
  }

  #TODO should this be configurable ?
  source_ranges = ["62.80.191.137/32"]
}

# Create Cloud NAT to avoid External IP on VM instances, but provide connection to exteranal resources
resource "google_compute_router" "router" {
  name    = "${var.project_id}-router"
  region  = google_compute_subnetwork.vpc-sub-network.region
  network = google_compute_network.vpc-network.id

  lifecycle {
    ignore_changes = [
      bgp
    ]
  }

}

resource "google_compute_router_nat" "nat" {
  name                   = "${var.project_id}-nat"
  router                 = google_compute_router.router.name
  region                 = google_compute_router.router.region

  nat_ip_allocate_option = "MANUAL_ONLY"
  nat_ips                = google_compute_address.static-nat.*.self_link
  min_ports_per_vm       = 64

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.vpc-sub-network.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
  
}
