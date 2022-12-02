# General
variable "project_id" {
  default     = ""
  type        = string
  description = "The project ID to host the cluster in"
}

variable "env_name" {
  default     = ""
  type        = string
  description = "Environment"
}

variable "region" {
  type        = string
  description = "The region to host the cluster in"
  default     = ""
}

variable "zone" {
  type        = string
  description = "The zone to host the cluster in"
  default     = ""
}

variable "tf_state_bucket_name" {
  default     = ""
  description = "Cloud Storage name"
}

# VPC
variable "vpc_range" {}
variable "vpc_subnetwork_range_1" {}
variable "vpc_subnetwork_range_2" {}

# GKE
variable "gke_cluster_version" {}
variable "k8s_master_ipv4_cidr_block" {}

variable "cluster_name" {
  default     = ""
  description = "GKE cluster name"
}

variable "gke_num_nodes" {
  default     = ""
  description = "The number of nodes per instance group"
}

variable "gke_num_node_pool" {
  default     = ""
  description = "The number of pools per instance group"
}

variable "gke_machine_type" {
  default     = "n1-standard-1"
  description = "The machine type to create"
}

variable "disk_size" {
  default     = 100
  description = " The size of the image in gigabytes"
}

# SQL
variable "sql_vm_count" {
  default     = "1"
  description = "Number of virtual SQL servers"
}

variable "mysql_root_password" {
  default     = "pass=word"
  description = "This variable is mandatory and specifies the password that will be set for the MySQL root superuser account. In the above example, it was set to my-secret-pw."
}

variable "mysql_user_api" {}
variable "mysql_user_migration" {}


# variable "vpc_serverless_range" {
#   default     = ""
#   description = "#TODO"
# }

# variable "gsm_project_id" {
#   default = ""
# }

# bucket
# variable "cdn_bucket" {
#   type        = string
#   description = "The name of the CDN bucket"
#   default     = "dynamic-assets"
# }
# variable "cert_name" {
#   type        = string
#   description = "The name of the certificate"
#   default     = "funtic-prod-certificate"
# }

# #mongo
# variable "mongo_image" {
#   default     = "mongo:4"
#   description = "MongoDB Docker image https://hub.docker.com/_/mongo?tab=tags"
# }
# variable "mongo_machine_type" {
#   default     = "n1-standard-2"
#   description = "The machine type to create"
# }
# variable "source_image" {
#   default     = "centos-7-v20210217"
#   description = "OS for VMs"
# }
# variable "mongo_disk_size" {
#   default     = 50
#   description = " The size of the image in gigabytes"
# }
# variable "mongo_user" {
#   default     = "monitoring"
#   description = "mongo user"
# }
# variable "mongo_password" {
#   default     = "W7vfrgLWE;3&]v~["
#   description = "mongo password"
# }
# variable "mongo_db" {
#   default     = "action-logs"
#   description = "Mongo database name"
# }
# variable "mongo_replicaset_name" {
#   default     = "rs0"
#   description = "mongodb replicaset name"
# }
# variable "mongo_listen_port" {
#   default     = "27017"
#   description = "mongodb listen port"
# }

# SQL cloud
variable "gcs_machine_type" {
  default     = "db-n1-standard-1"
  description = "The machine type to create"
}

# #rabbitMQ
# variable "rabbitmq_user" {
#   default     = "funtico_admin"
#   description = "rabbitmq user"
# }
# variable "rabbitmq_password" {
#   default     = "AB2WpJdqZ9RRrWH"
#   description = "rabbitmq password"
# }
# variable "rabbitmq_port" {
#   default     = "5672"
#   description = "rabbitmq port"
# }

# #gcb
# variable "branch_name" {
#   default     = "^master$"
#   description = "branch name for triggers"
# }
# variable "repo_name" {
#   default     = "funtico-dev"
#   description = "repository name"
# }
# variable "NODE_ENV" {
#   default     = "production"
#   description = "node environment for build"
# }
# variable "game" {
#   default     = ""
#   description = "main domain for client"
# }
# variable "bo" {
#   default     = ""
#   description = "BO domain"
# }
# variable "socketio" {
#   default     = ""
#   description = "socketio domain"
# }
# variable "voucher" {
#   default     = ""
#   description = "voucher domain"
# }

# #redis
# variable "redis_ram_size_gb" {
#   default     = "8"
#   description = "Redis RAM size in GB"
# }

#env
variable "DB_MASTER_NAME" {}
variable "DB_AUDIT_NAME" {}

# variable "DB_MASTER_USER" {
#   default = ""
# }
# variable "DB_MASTER_PSW" {
#   default = ""
# }