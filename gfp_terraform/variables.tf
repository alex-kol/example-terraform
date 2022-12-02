variable project_name {
  description = "The project name"
  type        = string
  default     = "gfp"
}

variable environment {
  description = "The environment"
  type        = string
  default     = ""
}

variable aws_region {
  description = "AWS region"
  type        = string
  default     = ""
}

variable aws_access_key {
  description = "AWS access key"
  type        = string
  default     = ""
}

variable aws_secret_key {
  description = "AWS secret"
  type        = string
  default     = ""
}

# VPC

variable cidr_network {
  description = "CIDR network"
  type        = map
  default = {
    dev         = "10.20"
    live        = "10.30"
  }
}

# SSH

variable aws_key_pair {
  description = "SSH public key for access to instance in AWS"
  type        = string
  default     = ""
}

variable ssh_client_ip {
  description = "Static ip for connection to AWS inctance"
  type        = list(string)
  default     = ["194.117.252.29/32", "195.62.14.236/32"]
}

variable data_ssh {
  description = "Data ssh for bastion"
  type        = string
  default     = ""
}

# domain

variable domain {
  description = "Domain name"
  type        = map
  default = {
    dev  = "dev.thegoodfaceproject.com"
    live = ""
  }
}

# redis

variable redis_number_cache_clusters {
  description = "Configuration mail driver for ar-app-backend"
  type        = map
  default = {
    dev   = "2"
    live  = "4"
  }
}

variable redis_node_type {
  description = "Configuration mail driver for ar-app-backend"
  type        = map
  default = {
    dev   = "cache.t2.small"
    live  = "cache.r5.large"
  }
}

# RDS

variable db_name {
  description = ""
  type        = string
  default     = ""
}

variable db_password {
  description = ""
  type        = string
  default     = ""
}

variable db_user {
  description = ""
  type        = string
  default     = ""
}

# EC2

variable instance_type {
  description = ""
  type        = map
  default = {
    dev   = "t3.medium"
    live  = "t3.large"
  }
}

variable spot_price {
  description = "Price instance"
  type        = string
  default = "1"
}

variable ecs_instance_min_size {
  description = "The number min instance in ECS"
  type        = map
  default = {
    dev   = "1"
    live  = "3"
  }
}

variable ecs_instance_max_size {
  description = "The number max instance in ECS"
  type        = map
  default = {
    dev   = "2"
    live  = "4"
  }
}
