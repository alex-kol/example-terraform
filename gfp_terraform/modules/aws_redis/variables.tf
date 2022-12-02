variable project_name {
  description = "Project name"
  type        = string
  default     = ""
}

variable role {
  description = ""
  type        = string
  default     = ""
}

variable number_cache_clusters {
  description = "This will attempt to automatically add or remove replicas"
  type        = string
  default     = "2"
}

variable node_type {
  description = ""
  type        = string
  default     = "cache.t3.small"
}

variable subnet_ids {
  description = ""
  type        = list(string)
  default     = []
}

variable vpc_id {
  description = ""
  type        = string
  default     = ""
}

variable security_groups {
  description = ""
  type        = list(string)
  default     = []
}

variable engine_version {
  description = "THe engine version for redis. For example: 5.0.6"
  type        = string
  default     = "5.0.6"
}

variable parameter_group_name {
  description = "The parameter group name for redis. For example: default.redis5.0"
  type        = string
  default     = "default.redis5.0"
}
