variable name {
  description = "The name"
  type        = string
  default     = ""
}

variable environment {
  description = "The environment"
  type        = string
  default     = ""
}

variable domain {
  description = "The domain name"
  type        = string
  default     = ""
}

variable port {
  description = "Port for connection to SSH"
  type        = string
  default     = 22
}

variable instance_type {
  description = "Instance type of SSH Bastion"
  type        = string
  default     = "t2.micro"
}

variable key_name {
  description = "name of the keypair to start the instances with"
  type        = string
  default     = ""
}

variable data_ssh {
  description = "Data ssh"
  type        = string
  default     = ""
}

variable vpc_id {
  description = "VPC identifier"
  type        = string
  default     = ""
}

variable subnet_ids {
  description = "list of public subnets to associate bastion with"
  type        = list(string)
  default     = []
}

variable region {
  description = "The AWS region to launch in"
  type        = string
  default     = ""
}

variable security_groups {
  description = "Security_groups for permission to bastion"
  type        = list(string)
  default     = []
}
