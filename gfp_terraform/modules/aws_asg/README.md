# AWS autoscaling group

## inputs

| variable             | type   | default | description                                                                                     |
| -------------------- | ------ | ------- | ----------------------------------------------------------------------------------------------- |
| name                 | string |         | The name                                                                                        |
| vpc_zone_identifier  | list   |         | The VPC zone identifier                                                                         |
| min_size             | string | 1       | The minimum size of the auto scale group.                                                       |
| desired_capacity     | string |         | The number of Amazon EC2 instances that should be running in the group.                         |
| max_size             | string |         | The maximum size of the autoscale group                                                         |
| launch_configuration | string |         | The launch configuration of the autoscale group                                                 |
| adjustment_type      | string |         | Specifies whether the adjustment is an absolute number or a percentage of the current capacity. |

## outputs

| variable  | type   | description                               |
| --------- | ------ | ----------------------------------------- |
| instances | string | IDs of instances found through the filter |

## usaged

```terraform
module asg {
  source                = "./modules/asg"
  project_name          = var.project_name
  vpc_zone_identifier   = data.aws_subnet_ids.private.ids
  min_size              = var.ecs_autoscale_minsize
  desired_capacity      = var.desired_capacity
  max_size              = var.ecs_autoscale_maxsize
  launch_configuration  = module.launch_config_ecs.instance
  adjustment_type       = var.adjustment_type
}
```
