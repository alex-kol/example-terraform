# AWS IAM

## Inputs

| variable    | type   | Default | Required | description                                |
| ----------- | ------ | ------- | -------- | ------------------------------------------ |
| name        | string | ""      | yes      | The name prefix for add resource           |
| environment | string | ""      | yes      | The name an environment for infrastructure |

## Outputs

| variable              | type   | description                   |
| --------------------- | ------ | ----------------------------- |
| ecs_task_arn          | string | ARN ecs task                  |
| ecs_task_role_name    | string | ECS task role name            |
| instance_profile_name | string | The name profile for instance |

## Usage

```terraform
module iam {
  source      = "./modules/aws_iam"
  name        = local.prefix
  environment = var.environment
}
```
