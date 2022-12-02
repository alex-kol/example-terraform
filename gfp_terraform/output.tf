output vpc_id_network {
  description = "ID private VPC"
  value       = module.vpc.vpc_id
}

output security_group_id_bastion {
  description = "ID security group bastion"
  value       = module.sg_bastion.sg_id
}
