resource "google_sql_database" "main-db" {
  project   = var.project_id
  name      = var.DB_MASTER_DATABASE
  instance  = google_sql_database_instance.master["funtico-data"].name
  charset   = "utf8"
  collation = "utf8_general_ci"
}

resource "google_sql_user" "main-db-user" {
  project  = var.project_id
  name     = var.DB_MASTER_USERNAME
  password = var.DB_MASTER_PASSWORD
  instance = google_sql_database_instance.master["funtico-data"].name
  host     = "%"
}

resource "google_sql_database" "main-audit-db" {
  project   = var.project_id
  name      = var.DB_AUDIT_DATABASE
  instance  = google_sql_database_instance.master["funtico-data"].name
  charset   = "utf8"
  collation = "utf8_general_ci"
}

resource "google_sql_user" "main-db-audit-user" {
  project  = var.project_id
  name     = var.DB_AUDIT_USERNAME
  password = var.DB_AUDIT_PASSWORD
  instance = google_sql_database_instance.master["funtico-data"].name
  host     = "%"
}

resource "google_sql_database" "history-db" {
  project   = var.project_id
  name      = var.DB_HISTORY_DATABASE
  instance  = google_sql_database_instance.master["funtico-history"].name
  charset   = "utf8"
  collation = "utf8_general_ci"
}

resource "google_sql_user" "history-db-user" {
  project  = var.project_id
  name     = var.DB_HISTORY_USERNAME
  password = var.DB_HISTORY_PASSWORD
  instance = google_sql_database_instance.master["funtico-history"].name
  host     = "%"
}
