terraform {
  required_version = ">= 0.15.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.44.0"
    }
  }
  
}

provider "google" {
  credentials = file("./json/tf_service_account.json")
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}
