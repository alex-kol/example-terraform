resource "google_cloudbuild_trigger" "app_cloudbuild_triggers" {
  for_each    = toset(var.apps)
  
  name        = "${each.key}"
  description = "${each.key} build"

  trigger_template {
    branch_name = "^${var.branch_name}$"
    repo_name   = var.repo_name
  }

  included_files = ["apps/${each.key}/**", "libs/**", "package.json"]

  substitutions = {
    _CLUSTER_NAME = google_container_cluster.primary.name
    _ZONE         = var.region
    _ENV          = var.env_name
    _APP_NAME     = each.key
  }

  filename = "apps/${each.key}/deployment/cloudbuild.yaml"
  tags     = ["build", "deploy", "${var.env_name}", "be"]
}

resource "google_cloudbuild_trigger" "db_migration_main" {
  name        = "db-migration-main"
  description = "db migration main build"

  trigger_template {
    branch_name = "^${var.branch_name}$"
    repo_name   = var.repo_name
  }

  substitutions = {
    _CLUSTER_NAME   = google_container_cluster.primary.name
    _ZONE           = var.region
    _ENV            = var.env_name
  }

  included_files = ["libs/dal/src/migrations/**"]

  filename = "libs/dal/deployment/cloudbuild-data-${var.env_name}.yaml"
  tags     = ["SQL", "migration", "${var.env_name}"]
}

resource "google_cloudbuild_trigger" "db_migration_audit" {
  name        = "db-migration-audit"
  description = "db migration audit build"
  disabled    = false

  trigger_template {
    branch_name = "^${var.branch_name}$"
    repo_name   = var.repo_name
  }

  substitutions = {
    _CLUSTER_NAME   = google_container_cluster.primary.name
    _ZONE           = var.region
    _ENV            = var.env_name
  }

  included_files = ["libs/dal/src/migrationsAudit/**"]

  filename = "libs/dal/deployment/cloudbuild-audit-${var.env_name}.yaml"
  tags     = ["SQL", "migration", "${var.env_name}"]
}

resource "google_cloudbuild_trigger" "db_migration_history" {
  name        = "db-migration-history"
  description = "db migration history build"

  trigger_template {
    branch_name = "^${var.branch_name}$"
    repo_name   = var.repo_name
  }

  substitutions = {
    _CLUSTER_NAME   = google_container_cluster.primary.name
    _ZONE           = var.region
    _ENV            = var.env_name
  }

  included_files = ["libs/dal/src/migrationsHistory/**"]

  filename = "libs/dal/deployment/cloudbuild-history-${var.env_name}.yaml"
  tags     = ["SQL", "migration", "${var.env_name}"]
}

resource "google_cloudbuild_trigger" "bo_fe_cloudbuild_trigger" {
  name        = "service-bo-fe"
  description = "service-bo-fe build"

  trigger_template {
    branch_name = "^${var.branch_name}$"
    repo_name   = var.repo_name
  }

  included_files = ["service-bo-fe/**"]

  substitutions = {
    _CLUSTER_NAME = google_container_cluster.primary.name
    _ZONE         = var.region
    _ENV          = var.env_name
    _APP_NAME     = "service-bo-fe"
    _BUILD_ENV    = var.angular_build_env
  }

  filename = "service-bo-fe/deployment/cloudbuild.yaml"
  tags     = ["build", "deploy", "${var.env_name}", "fe"]
}

resource "google_cloudbuild_trigger" "app_cloudbuild_triggers_games" {
  for_each    = toset(var.games)

  name        = "${each.key}"
  description = "${each.key} unity3d build"

  trigger_template {
    branch_name = "^${var.branch_name}$"
    repo_name   = var.repo_name_games
  }

  included_files = ["${each.key}/**"]

  substitutions = {
    _CLUSTER_NAME = google_container_cluster.primary.name
    _ZONE         = var.region
    _ENV          = var.env_name
    _APP_NAME     = each.key
  }

  filename = "${each.key}/deployment/cloudbuild-${var.env_name}.yaml"
  tags     = ["build", "deploy", "${var.env_name}", "games"]
}
