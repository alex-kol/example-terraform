resource "google_secret_manager_secret" "BUCKET_HOST" {
  secret_id = "BUCKET_HOST"

  labels = {
    label = "bucket_host"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-BUCKET_HOST" {
  secret      = google_secret_manager_secret.BUCKET_HOST.id
  secret_data = var.BUCKET_HOST
}

resource "google_secret_manager_secret" "BUCKET_NAME" {
  secret_id = "BUCKET_NAME"

  labels = {
    label = "bucket_name"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-BUCKET_NAME" {
  secret      = google_secret_manager_secret.BUCKET_NAME.id
  secret_data = var.BUCKET_NAME
}

resource "google_secret_manager_secret" "CLIENT_FE_BASE_URL" {
  secret_id = "CLIENT_FE_BASE_URL"

  labels = {
    label = "client_fe_base_url"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-CLIENT_FE_BASE_URL" {
  secret      = google_secret_manager_secret.CLIENT_FE_BASE_URL.id
  secret_data = var.CLIENT_FE_BASE_URL
}

resource "google_secret_manager_secret" "DB_AUDIT_HOST" {
  secret_id = "DB_AUDIT_HOST"

  labels = {
    label = "db_audit_host"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-DB_AUDIT_HOST" {
  secret      = google_secret_manager_secret.DB_AUDIT_HOST.id
  secret_data = var.DB_AUDIT_HOST
}

resource "google_secret_manager_secret" "DB_AUDIT_USERNAME" {
  secret_id = "DB_AUDIT_USERNAME"

  labels = {
    label = "db_audit_username"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-DB_AUDIT_USERNAME" {
  secret      = google_secret_manager_secret.DB_AUDIT_USERNAME.id
  secret_data = var.DB_AUDIT_USERNAME
}

resource "google_secret_manager_secret" "DB_AUDIT_PASSWORD" {
  secret_id = "DB_AUDIT_PASSWORD"

  labels = {
    label = "db_audit_password"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-DB_AUDIT_PASSWORD" {
  secret      = google_secret_manager_secret.DB_AUDIT_PASSWORD.id
  secret_data = var.DB_AUDIT_PASSWORD
}

resource "google_secret_manager_secret" "DB_AUDIT_DATABASE" {
  secret_id = "DB_AUDIT_DATABASE"

  labels = {
    label = "db_audit_database"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-DB_AUDIT_DATABASE" {
  secret      = google_secret_manager_secret.DB_AUDIT_DATABASE.id
  secret_data = var.DB_AUDIT_DATABASE
}

resource "google_secret_manager_secret" "DB_HISTORY_DATABASE" {
  secret_id = "DB_HISTORY_DATABASE"

  labels = {
    label = "db_history_database"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-DB_HISTORY_DATABASE" {
  secret      = google_secret_manager_secret.DB_HISTORY_DATABASE.id
  secret_data = var.DB_HISTORY_DATABASE
}

resource "google_secret_manager_secret" "DB_HISTORY_HOST" {
  secret_id = "DB_HISTORY_HOST"

  labels = {
    label = "db_history_host"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-DB_HISTORY_HOST" {
  secret      = google_secret_manager_secret.DB_HISTORY_HOST.id
  secret_data = var.DB_HISTORY_HOST
}

resource "google_secret_manager_secret" "DB_HISTORY_PASSWORD" {
  secret_id = "DB_HISTORY_PASSWORD"

  labels = {
    label = "db_history_password"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-DB_HISTORY_PASSWORD" {
  secret      = google_secret_manager_secret.DB_HISTORY_PASSWORD.id
  secret_data = var.DB_HISTORY_PASSWORD
}

resource "google_secret_manager_secret" "DB_HISTORY_USERNAME" {
  secret_id = "DB_HISTORY_USERNAME"

  labels = {
    label = "db_history_username"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-DB_HISTORY_USERNAME" {
  secret      = google_secret_manager_secret.DB_HISTORY_USERNAME.id
  secret_data = var.DB_HISTORY_USERNAME
}

resource "google_secret_manager_secret" "DB_SLAVE_HISTORY_DATABASE" {
  secret_id = "DB_SLAVE_HISTORY_DATABASE"

  labels = {
    label = "db_slave_history_database"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-DB_SLAVE_HISTORY_DATABASE" {
  secret      = google_secret_manager_secret.DB_SLAVE_HISTORY_DATABASE.id
  secret_data = var.DB_SLAVE_HISTORY_DATABASE
}

resource "google_secret_manager_secret" "DB_SLAVE_HISTORY_HOST" {
  secret_id = "DB_SLAVE_HISTORY_HOST"

  labels = {
    label = "db_slave_history_host"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-DB_SLAVE_HISTORY_HOST" {
  secret      = google_secret_manager_secret.DB_SLAVE_HISTORY_HOST.id
  secret_data = var.DB_SLAVE_HISTORY_HOST
}

resource "google_secret_manager_secret" "DB_SLAVE_HISTORY_PASSWORD" {
  secret_id = "DB_SLAVE_HISTORY_PASSWORD"

  labels = {
    label = "db_slave_history_password"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-DB_SLAVE_HISTORY_PASSWORD" {
  secret      = google_secret_manager_secret.DB_SLAVE_HISTORY_PASSWORD.id
  secret_data = var.DB_SLAVE_HISTORY_PASSWORD
}

resource "google_secret_manager_secret" "DB_SLAVE_HISTORY_USERNAME" {
  secret_id = "DB_SLAVE_HISTORY_USERNAME"

  labels = {
    label = "db_slave_history_username"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-DB_SLAVE_HISTORY_USERNAME" {
  secret      = google_secret_manager_secret.DB_SLAVE_HISTORY_USERNAME.id
  secret_data = var.DB_SLAVE_HISTORY_USERNAME
}

resource "google_secret_manager_secret" "DB_MASTER_DATABASE" {
  secret_id = "DB_MASTER_DATABASE"

  labels = {
    label = "db_master_database"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-DB_MASTER_DATABASE" {
  secret      = google_secret_manager_secret.DB_MASTER_DATABASE.id
  secret_data = var.DB_MASTER_DATABASE
}

resource "google_secret_manager_secret" "DB_MASTER_HOST" {
  secret_id = "DB_MASTER_HOST"

  labels = {
    label = "db_master_host"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-DB_MASTER_HOST" {
  secret      = google_secret_manager_secret.DB_MASTER_HOST.id
  secret_data = var.DB_MASTER_HOST
}

resource "google_secret_manager_secret" "DB_MASTER_PASSWORD" {
  secret_id = "DB_MASTER_PASSWORD"

  labels = {
    label = "db_master_password"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-DB_MASTER_PASSWORD" {
  secret      = google_secret_manager_secret.DB_MASTER_PASSWORD.id
  secret_data = var.DB_MASTER_PASSWORD
}

resource "google_secret_manager_secret" "DB_MASTER_USERNAME" {
  secret_id = "DB_MASTER_USERNAME"

  labels = {
    label = "db_master_username"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-DB_MASTER_USERNAME" {
  secret      = google_secret_manager_secret.DB_MASTER_USERNAME.id
  secret_data = var.DB_MASTER_USERNAME
}

resource "google_secret_manager_secret" "DB_SLAVE_DATABASE" {
  secret_id = "DB_SLAVE_DATABASE"

  labels = {
    label = "db_slave_database"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-DB_SLAVE_DATABASE" {
  secret      = google_secret_manager_secret.DB_SLAVE_DATABASE.id
  secret_data = var.DB_SLAVE_DATABASE
}

resource "google_secret_manager_secret" "DB_SLAVE_HOST" {
  secret_id = "DB_SLAVE_HOST"

  labels = {
    label = "db_slave_host"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-DB_SLAVE_HOST" {
  secret      = google_secret_manager_secret.DB_SLAVE_HOST.id
  secret_data = var.DB_SLAVE_HOST
}

resource "google_secret_manager_secret" "DB_SLAVE_PASSWORD" {
  secret_id = "DB_SLAVE_PASSWORD"

  labels = {
    label = "db_slave_password"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-DB_SLAVE_PASSWORD" {
  secret      = google_secret_manager_secret.DB_SLAVE_PASSWORD.id
  secret_data = var.DB_SLAVE_PASSWORD
}

resource "google_secret_manager_secret" "DB_SLAVE_USERNAME" {
  secret_id = "DB_SLAVE_USERNAME"

  labels = {
    label = "db_slave_username"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-DB_SLAVE_USERNAME" {
  secret      = google_secret_manager_secret.DB_SLAVE_USERNAME.id
  secret_data = var.DB_SLAVE_USERNAME
}

resource "google_secret_manager_secret" "EURO_EXCHANGE_RATES_URL" {
  secret_id = "EURO_EXCHANGE_RATES_URL"

  labels = {
    label = "euro_exchange_rates_url"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-EURO_EXCHANGE_RATES_URL" {
  secret      = google_secret_manager_secret.EURO_EXCHANGE_RATES_URL.id
  secret_data = var.EURO_EXCHANGE_RATES_URL
}

resource "google_secret_manager_secret" "FUNTICO_WEBHOOK_IP_WHITELIST" {
  secret_id = "FUNTICO_WEBHOOK_IP_WHITELIST"

  labels = {
    label = "funtico_webhook_ip_whitelist"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-FUNTICO_WEBHOOK_IP_WHITELIST" {
  secret      = google_secret_manager_secret.FUNTICO_WEBHOOK_IP_WHITELIST.id
  secret_data = var.FUNTICO_WEBHOOK_IP_WHITELIST
}

resource "google_secret_manager_secret" "GAME_URL_DOMAIN" {
  secret_id = "GAME_URL_DOMAIN"

  labels = {
    label = "game_url_domain"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-GAME_URL_DOMAIN" {
  secret      = google_secret_manager_secret.GAME_URL_DOMAIN.id
  secret_data = var.GAME_URL_DOMAIN
}

resource "google_secret_manager_secret" "HISTORY_DOMAIN" {
  secret_id = "HISTORY_DOMAIN"

  labels = {
    label = "history_domain"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-HISTORY_DOMAIN" {
  secret      = google_secret_manager_secret.HISTORY_DOMAIN.id
  secret_data = var.HISTORY_DOMAIN
}

resource "google_secret_manager_secret" "JWT_QUERY_SECRET" {
  secret_id = "JWT_QUERY_SECRET"

  labels = {
    label = "jwt_query_secret"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-JWT_QUERY_SECRET" {
  secret      = google_secret_manager_secret.JWT_QUERY_SECRET.id
  secret_data = var.JWT_QUERY_SECRET
}

resource "google_secret_manager_secret" "JWT_SECRET" {
  secret_id = "JWT_SECRET"

  labels = {
    label = "jwt_secret"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-JWT_SECRET" {
  secret      = google_secret_manager_secret.JWT_SECRET.id
  secret_data = var.JWT_SECRET
}

resource "google_secret_manager_secret" "OPERATORS" {
  secret_id = "OPERATORS"

  labels = {
    label = "operators"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-OPERATORS" {
  secret      = google_secret_manager_secret.OPERATORS.id
  secret_data = var.OPERATORS
}

resource "google_secret_manager_secret" "RABBITMQ_HOST" {
  secret_id = "RABBITMQ_HOST"

  labels = {
    label = "rabbitmq_host"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-RABBITMQ_HOST" {
  secret      = google_secret_manager_secret.RABBITMQ_HOST.id
  secret_data = var.RABBITMQ_HOST
}

resource "google_secret_manager_secret" "RABBITMQ_USERNAME" {
  secret_id = "RABBITMQ_USERNAME"

  labels = {
    label = "rabbitmq_username"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-RABBITMQ_USERNAME" {
  secret      = google_secret_manager_secret.RABBITMQ_USERNAME.id
  secret_data = var.RABBITMQ_USERNAME
}

resource "google_secret_manager_secret" "RABBITMQ_PASSWORD" {
  secret_id = "RABBITMQ_PASSWORD"

  labels = {
    label = "rabbitmq_password"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-RABBITMQ_PASSWORD" {
  secret      = google_secret_manager_secret.RABBITMQ_PASSWORD.id
  secret_data = var.RABBITMQ_PASSWORD
}

resource "google_secret_manager_secret" "REDIS_HOST" {
  secret_id = "REDIS_HOST"

  labels = {
    label = "redis_host"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-REDIS_HOST" {
  secret      = google_secret_manager_secret.REDIS_HOST.id
  secret_data = var.REDIS_HOST
}

resource "google_secret_manager_secret" "STALE_TOKEN_THRESHOLD_SEC" {
  secret_id = "STALE_TOKEN_THRESHOLD_SEC"

  labels = {
    label = "stale_token_threshold_sec"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-STALE_TOKEN_THRESHOLD_SEC" {
  secret      = google_secret_manager_secret.STALE_TOKEN_THRESHOLD_SEC.id
  secret_data = var.STALE_TOKEN_THRESHOLD_SEC
}

resource "google_secret_manager_secret" "SYSTEM_LOG_LEVEL" {
  secret_id = "SYSTEM_LOG_LEVEL"

  labels = {
    label = "system_log_level"
  }

  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}
resource "google_secret_manager_secret_version" "secret-SYSTEM_LOG_LEVEL" {
  secret      = google_secret_manager_secret.SYSTEM_LOG_LEVEL.id
  secret_data = var.SYSTEM_LOG_LEVEL
}
