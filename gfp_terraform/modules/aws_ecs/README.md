# AWS ECS

## inputs

| variable | type   | default | description  |
| -------- | ------ | ------- | ------------ |
| name     | string | "test"  | Cluster name |

## outputs

| variable     | type   | description  |
| ------------ | ------ | ------------ |
| cluster_name | string | Cluster name |
| cluster_id   | string | ID cluster   |
| cluster_arn  | string | Cluster arn  |


## use

```terraform
module ecs {
  source              = "./modules/ecs"
  project_name        = var.name
}
```
