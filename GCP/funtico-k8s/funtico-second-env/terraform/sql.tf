resource "google_sql_database_instance" "master" {
  project             = var.project_id
  name                = "${var.project_id}-master-${count.index}"
  count               = var.sql_vm_count
  database_version    = "MYSQL_8_0"
  region              = var.region
  deletion_protection = false

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier              = var.gcs_machine_type
    availability_type = "REGIONAL"
    disk_size         = "200"

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
    }
  }

  lifecycle {
    ignore_changes = [
      settings["maintenance_window"],
    ]
  }
}

resource "google_sql_database" "database-main" {
  project   = var.project_id
  name      = var.DB_MASTER_NAME
  count     = var.sql_vm_count
  instance  = google_sql_database_instance.master[count.index].name
  charset   = "utf8"
  collation = "utf8_general_ci"
}

resource "google_sql_database" "database-audit" {
  project   = var.project_id
  name      = var.DB_AUDIT_NAME
  count     = var.sql_vm_count
  instance  = google_sql_database_instance.master[count.index].name
  charset   = "utf8"
  collation = "utf8_general_ci"
}

resource "google_sql_user" "api-user" {
  project  = var.project_id
  name     = var.mysql_user_api
  count    = var.sql_vm_count
  instance = google_sql_database_instance.master[count.index].name
  # password = var.DB_MASTER_PSW
  host     = "%"

  # depends_on = [google_sql_database_instance.master[count.index]]
}

resource "google_sql_user" "migrations" {
  
  project  = var.project_id
  name     = var.mysql_user_migration
  count    = var.sql_vm_count
  instance = google_sql_database_instance.master[count.index].name
  password = var.mysql_root_password
  host     = "localhost"

  # depends_on = [google_sql_database_instance.master[count.index]]
}

resource "google_sql_database_instance" "slave" {
  project              = var.project_id
  name                 = "${var.project_id}-slave-${count.index}"
  count                = var.sql_vm_count
  master_instance_name = google_sql_database_instance.master[count.index].name
  region               = var.region
  database_version     = "MYSQL_8_0"
  deletion_protection  = false

  replica_configuration {
    failover_target = false
  }

  settings {
    tier              = var.gcs_machine_type
    availability_type = "ZONAL"
    disk_size         = "200"

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
