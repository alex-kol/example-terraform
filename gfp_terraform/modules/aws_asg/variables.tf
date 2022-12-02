variable name {
  description = "The name"
  type        = string
  default     = ""
}

variable vpc_zone_identifier {
  description = "The VPC zone identifier"
  type        = list(string)
  default     = []
}

variable min_size {
  description = "The minimum size of the auto scale group."
  type        = string
  default     = "1"
}

variable desired_capacity {
  description = "The number of Amazon EC2 instances that should be running in the group."
  type        = string
  default     = "1"
}

variable max_size {
  description = "The maximum size of the autoscale group"
  type        = string
  default     = ""
}

variable launch_configuration {
  description = "The launch configuration of the autoscale grou"
  type        = string
  default     = ""
}

variable adjustment_type {
  description = "Specifies whether the adjustment is an absolute number or a percentage of the current capacity. Valid values are ChangeInCapacity, ExactCapacity, and PercentChangeInCapacity."
  type        = string
  default     = ""
}
