variable name {
  description = "Name"
  type        = string
  default     = "test"
}


variable project_name {
  description = "Project name"
  type        = string
  default     = ""
}

variable availability_zone {
  description = "Availability zone"
  type        = string
  default     = ""
}

variable vpc_security_group_ids {
  description = ""
  type        = list(string)
  default     = []
}

variable engine {
  description = ""
  type        = string
  default     = "mysql"
}

variable engine_version {
  description = ""
  type        = string
  default     = "5.7"
}

variable instance_class {
  description = ""
  type        = string
  default     = "db.r4.large"
}

variable db_port {
  description = "Database port"
  type        = string
  default     = ""
}

variable db_name {
  description = "Database name"
  type        = string
  default     = ""
}

variable db_user_passwd {
  description = "Database user password"
  type        = string
  default     = ""
}

variable skip_final_snapshot {
  description = ""
  type        = string
  default     = "true"
}

variable storage_type {
  description = ""
  type        = string
  default     = "gp2"
}

variable allocated_storage {
  description = ""
  type        = string
  default     = "10"
}

variable db_user {
  description = ""
  type        = string
  default     = "user"
}

variable parameter_group_name {
  description = ""
  type        = string
  default     = "default.mysql5.7"
}

variable subnet_ids {
  description = ""
  type        = list(string)
  default     = []
}

variable security_groups {
  description = "Security_groups"
  type        = list(string)
  default     = []
}

variable vpc_id {
  description = "VPC id"
  type        = string
  default     = ""
}

variable license_model {
  description = ""
  type        = string
  default     = "general-public-license"
}
