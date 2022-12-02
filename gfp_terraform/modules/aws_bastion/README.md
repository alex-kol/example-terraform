# AWS Bastion

## inputs

| variable        | type   | default | description                                      |
| --------------- | ------ | ------- | ------------------------------------------------ |
| name            | string | ""      | Name                                             |
| environment     | string | ""      | Environment                                      |
| domain          | string | ""      | The domain name                                  |
| port            | string | 22      | Port for connection to SSH                       |
| instance_type   | string | t2.micro| Instance type of SSH Bastion                     |
| key_name        | string | ""      | name of the keypair to start the instances with  |
| data_ssh        | string | ""      | data_ssh for bash script                         |
| vpc_id          | string | ""      | VPC identifier                                   |
| subnet_ids      | list   | []      | list of public subnets to associate bastion with |
| region          | string | ""      | The AWS region to launch in                      |
| security_groups | list   | []      |                                                  |

## outputs

| variable | type | description |
| -------- | ---- | ----------- |
| dns_name |string| DNS name    |

## usage

```terraform
module bastion {
  source          = "./modules/aws_bastion"
  name            = "${local.prefix}-bastion"
  environment     = var.environment
  security_groups = [module.sg_bastion.sg_id]
  key_name        = aws_key_pair.ecs_key.key_name
  domain          = lookup(var.domain, var.environment)
  data_ssh        = var.data_ssh
  vpc_id          = module.vpc.vpc_id
  subnet_ids      = module.vpc.subnet_id
  region          = var.aws_region
  instance_type   = "t2.micro"
}
```
