resource "google_sql_database_instance" "master" {
  for_each            = toset(var.names_vm_sql)

  project             = var.project_id
  name                = "${each.key}-master"
  database_version    = "MYSQL_8_0"
  region              = var.region
  deletion_protection = false # set to true to prevent destruction of the resource

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier              = var.gcs_machine_type
    availability_type = "REGIONAL"
    disk_size         = var.disk_size_sql

    database_flags {
      name  = "wait_timeout"
      value = "30"
    }

    database_flags {
      name  = "innodb_buffer_pool_size"
      value = "1369020825"
    }

    backup_configuration {
      location           = "eu"
      enabled            = true
      binary_log_enabled = true
      start_time         = "04:00"
    }

    maintenance_window {
      day  = 1
      hour = 0
    }

    ip_configuration {
      ipv4_enabled    = true
      require_ssl     = false
      private_network = google_compute_network.vpc-network.id

      dynamic "authorized_networks" {
        for_each = local.white_list
        iterator = white_list

        content {
          name  = "VPN DigiCode-${white_list.key}"
          value = white_list.value
        }
      }

      # authorized_networks {
      #   name  = "External Access"
      #   value = "0.0.0.0/0"
      # }

    }
  }

  lifecycle {
    ignore_changes = [
      settings["maintenance_window"],
    ]
  }
}

resource "google_sql_database_instance" "slave" {
  for_each             = toset(var.names_vm_sql)
  
  project              = var.project_id
  name                 = "${each.key}-slave"
  master_instance_name = google_sql_database_instance.master[each.key].name
  region               = var.region
  database_version     = "MYSQL_8_0"
  deletion_protection  = false

  replica_configuration {
    failover_target = false
  }

  settings {
    tier              = var.gcs_machine_type
    availability_type = "ZONAL"
    disk_size         = var.disk_size_sql

    database_flags {
      name  = "wait_timeout"
      value = "30"
    }

    database_flags {
      name  = "long_query_time"
      value = "0.1"
    }

    database_flags {
      name  = "slow_query_log"
      value = "on"
    }

    database_flags {
      name  = "innodb_buffer_pool_size"
      value = "1369020825"
    }

    backup_configuration {
      enabled = false
    }

    ip_configuration {
      ipv4_enabled    = false
      require_ssl     = false
      private_network = google_compute_network.vpc-network.id
      
    }
  }

  lifecycle {
    ignore_changes = [
      settings["maintenance_window"],

    ]
  }

}
