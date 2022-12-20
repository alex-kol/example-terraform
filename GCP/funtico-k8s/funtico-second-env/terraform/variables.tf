# General
variable "project_id" {
  type        = string
  default     = "projectID"
  description = "The project ID to host the cluster in"
}

variable "env_name" {
  type        = string
  default     = "develop"
  description = "Environment"
}

variable "region" {
  type        = string
  default     = "europe-west3"
  description = "The region to host the cluster in"
}

variable "zone" {
  type        = string
  default     = "europe-west3-a"
  description = "The zone to host the cluster in"
}

# S3 bucket
variable "tf_state_bucket_name" {
  type        = string
  default     = "project_bucket"
  description = "Cloud Storage name"
}

# Storage CDN
# variable "cdn_bucket" {
#   type        = string
#   default     = "dynamic-assets"
#   description = "The name of the CDN bucket"
# }

# variable "cert_name" {
#   type        = string
#   default     = "certificate"
#   description = "The name of the certificate"
# }

# VPC
variable "vpc_range" {
  default     = "10.10.0.0/16"
}

variable "vpc_subnet_range_1" {
  default     = "10.20.0.0/16"
}

variable "vpc_subnet_range_2" {
  default     = "10.30.0.0/16"
}

variable "vpc_serverless_range" {
  default     = "10.40.1.0/28"
}

# GKE
variable "gke_cluster_version" {
  type        = string
  default     = "1.23.12-gke.100"
  description = "GKE version"
}

variable "k8s_master_ipv4_cidr_block" {
  type        = string
  default     = "10.40.2.0/28"
  description = "GKE k8s ipv4"
}

variable "cluster_name" {
  type        = string
  default     = "project-env"
  description = "GKE cluster name"
}

variable "gke_num_nodes" {
  type        = string
  default     = "1"
  description = "The number of nodes per instance group"
}

variable "gke_num_node_pool" {
  type        = string
  default     = "1"
  description = "The number of pools per instance group"
}

variable "gke_machine_type" {
  type        = string
  default     = "n1-standard-1"
  description = "The machine type to create"
}

variable "disk_size" {
  type        = string
  default     = 15
  description = " The size of the image in gigabytes"
}

# Redis
variable "redis_version" {
  type        = string
  default     = "REDIS_6_X"
  description = "Redis version"
}

# Read replicas are only supported on instance sizes 5GB and above
variable "redis_ram_size_gb" {
  type        = string
  default     = "5"
  description = "Redis RAM size in GB"
}

variable "redis_replica" {
  type        = string
  default     = "1"
  description = "Redis replica count"
}

# GCB
variable "repo_name" {
  type        = string
  default     = "bitbucket_"
  description = "Repository name from Cloud Source Repositories"
}

variable "repo_name_games" {
  type        = string
  default     = "bitbucket_"
  description = "Repository name from Cloud Source Repositories"
}

variable "branch_name" {
  type        = string
  default     = "develop"
  description = "Branch name from repo"
}

variable "angular_build_env" {
  type        = string
  default     = "development"
  description = "BUILD_ENV for service-bo-fe from angular.json"
}

variable "apps" {
  type    = list(any)
  default = [
    "service-bo-api",
    "service-c2s",
    "service-game-core",
    "service-history",
    "service-ms",
    "service-s2s",
    "client-socketio-node",
    "service-game-core-worker",
  ]
  description = "List of apps for gcr and gcb"
}

variable "games" {
  type    = list(any)
  default = [
    "game-bingo",
    "game-scratch",
  ]
  description = "List of apps for gcr and gcb"
}

# SQL
variable "names_vm_sql" {
  type    = list(any)
  default = [
    "database-data",
    "database-history",
  ]
  description = "List of name instances for SQL"
}

variable "gcs_machine_type" {
  type        = string
  default     = "db-n1-standard-1"
  description = "The machine type to create"
}

variable "disk_size_sql" {
  type        = string
  default     = 50
  description = " The size of the image in gigabytes"
}

# Secret manager data
variable "BUCKET_HOST" {}
variable "BUCKET_NAME" {}
variable "CLIENT_FE_BASE_URL" {}

# SQL funtico-audit
variable "DB_AUDIT_HOST" {}
variable "DB_AUDIT_USERNAME" {}
variable "DB_AUDIT_PASSWORD" {}
variable "DB_AUDIT_DATABASE" {}

# SQL funtico-data
variable "DB_MASTER_HOST" {}
variable "DB_MASTER_USERNAME" {}
variable "DB_MASTER_PASSWORD" {}
variable "DB_MASTER_DATABASE" {}
variable "DB_SLAVE_HOST" {}
variable "DB_SLAVE_USERNAME" {}
variable "DB_SLAVE_PASSWORD" {}
variable "DB_SLAVE_DATABASE" {}

# SQL funtico-history
variable "DB_HISTORY_HOST" {}
variable "DB_HISTORY_USERNAME" {}
variable "DB_HISTORY_PASSWORD" {}
variable "DB_HISTORY_DATABASE" {}
variable "DB_SLAVE_HISTORY_HOST" {}
variable "DB_SLAVE_HISTORY_USERNAME" {}
variable "DB_SLAVE_HISTORY_PASSWORD" {}
variable "DB_SLAVE_HISTORY_DATABASE" {}

variable "EURO_EXCHANGE_RATES_URL" {}
variable "FUNTICO_WEBHOOK_IP_WHITELIST" {}
variable "GAME_URL_DOMAIN" {}
variable "HISTORY_DOMAIN" {}
variable "JWT_QUERY_SECRET" {}
variable "JWT_SECRET" {}
variable "OPERATORS" {}
variable "RABBITMQ_HOST" {}
variable "RABBITMQ_USERNAME" {}
variable "RABBITMQ_PASSWORD" {}
variable "REDIS_HOST" {}
variable "STALE_TOKEN_THRESHOLD_SEC" {}

variable "SYSTEM_LOG_LEVEL" {
  type        = string
  default     = "debug"
}
