# AWS REDIS

## inputs

| variable        | type         | description  |
| --------------- | ------------ | ------------ |
| project_name    | string       | Project name |
| node_type       | string       |              |
| subnet_ids      |              |              |
| vpc_id          | string       |              |
| security_groups | list(string) |              |


## outputs

| variable               | type   | description        |
| ---------------------- | ------ | ------------------ |
| redis_primary_endpoint | string | Redis primary host |

## use

```terraform
module redis {
  source          = "./modules/redis"
  project_name    = var.project_name
  node_type       = var.node_type
  subnet_ids      = data.aws_subnet_ids.private.ids
  vpc_id          = module.vpc.vpc_id
  security_groups = [module.sg_web.sg_id]
}
```
