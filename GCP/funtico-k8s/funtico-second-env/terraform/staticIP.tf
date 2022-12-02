resource "google_compute_global_address" "static" {
  name = "${var.project_id}-static"
}

resource "google_compute_address" "static-nat" {
  count  = 2
  name   = "${var.project_id}-static-nat-${count.index}"
  region = google_compute_subnetwork.vpc-sub-network.region
}
