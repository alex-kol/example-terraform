# AWS launch configuration

## inputs
| variable                    | type         | default | description                                               |
| --------------------------- | ------------ | ------- | --------------------------------------------------------- |
| name                        | string       | ""      | The name                                                  |
| key_name                    | string       | ""      | The name key pair                                         |
| instance_type               | string       | ""      | Type instance                                             |
| associate_public_ip_address | string       | "false" | Associating a public IP address with an instance in a VPC |
| spot_price                  | string       | ""      | The spot price                                            |
| security_groups             | list(string) | []      | The ID list security groups                               |
| iam_instance_profile        | string       | ""      | The name instance profile from IAM                        |
| image_id                    | string       | ""      | The ID ami                                                |
| newrelic_lic_key            | string       | ""      | NEW_RELIC_API_KEY                                         |
| volume_type                 | string       | "gp2"   | The type of EBS volume                                    |
| volume_size                 | string       | "10"    | The size of the drive in GiBs                             |
| iops                        | string       | "500"   | The amount of IOPS to provision for the disk.             |

## outputs
| variable | type   | description |
| -------- | ------ | ----------- |
| instance | string |             |

## use

```terraform
######### ami for ecs ##############

data aws_ami amazon-ami {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["amazon"]
}

module launch_config_ecs {
  source                      = "./modules/aws_launch_config"
  name                        = "${var.project_name}-${var.environment}"
  image_id                    = data.aws_ami.amazon-ami.id
  instance_type               = "c5.xlarge"
  iam_instance_profile        = module.iam.instance_profile_name
  key_name                    = aws_key_pair.ecs_key.key_name
  associate_public_ip_address = var.aws_internal_load_balancer
  spot_price                  = var.spot_price
  security_groups             = [module.sg_app.sg_id]
  newrelic_lic_key            = var.newrelic_lic_key
  volume_type                 = "io1"
  volume_size                 = "10"
  iops                        = "500"
}
```
