
locals {
  prefix = "${var.project_name}-${var.environment}"
}

# Settings for security group bastion

locals {
  permission_bastion = [
    {
      name            = "SSH"
      from_port       = "22"
      to_port         = "22"
      protocol        = "tcp"
      cidr_blocks     = var.ssh_client_ip
      security_groups = []
    }
  ]
}

# Settings for security group web

locals {
  permission_web = [
    {
      name            = "HTTP"
      from_port       = "80"
      to_port         = "80"
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
      security_groups = []
    },
    {
      name            = "HTTPS"
      from_port       = "443"
      to_port         = "443"
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"]
      security_groups = []
    },
    {
      name            = "SSH"
      from_port       = "22"
      to_port         = "22"
      protocol        = "tcp"
      cidr_blocks     = []
      security_groups = [module.sg_bastion.sg_id]
    }
  ]
}
