terraform {
  required_version = ">= 0.12"

  required_providers {
    google = {
      source = "hashicorp/google"
      version = "~> 3.46.0"
    }
  }
  
}

provider "google" {
  credentials = file("./json/tf_service_account.json")

  project = var.project_id
  region  = var.region
  zone    = var.zone
}
