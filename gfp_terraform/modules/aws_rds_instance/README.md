# AWS RDS instance

## inputs
| variable               | type         | default                | description            |
| ---------------------- | ------------ | ---------------------- | ---------------------- |
| name                   | string       | test                   | Name                   |
| project_name           | string       |                        | Project name           |
| availability_zone      | string       |                        | Availability zone      |
| vpc_security_group_ids | list(string) | []                     |                        |
| engine                 | string       | mysql                  |                        |
| engine_version         | string       | 5.7                    |                        |
| instance_class         | string       | db.r4.large            |                        |
| db_port                | string       | 3306                   | Database port          |
| db_name                | string       |                        | Database name          |
| db_user_passwd         | string       |                        | Database user password |
| final_snapshot         | string       | true                   |                        |
| storage_type           | string       | gp2                    |                        |
| allocated_storage      | string       | 10                     |                        |
| db_user                | string       | user                   |                        |
| parameter_group_name   | string       | default.mysql5.7       |                        |
| subnet_ids             | list(string) |                        |                        |
| security_groups        | list(string) |                        | Security_groups        |
| vpc_id                 | string       |                        | ID VPC                 |
| license_model          | string       | general-public-license | Setting for mysql      |

## outputs
| variable | type   | description |
| -------- | ------ | ----------- |
| db_host  | string | DB host     |

## use
```terraform
# create rds instance mysql

module rds_instance {
  source                = "./modules/rds_instance"
  name                  = "rds-server"
  availability_zone     = "${var.aws_region}a"
  project_name          = var.project_name
  engine                = "mysql"
  engine_version        = "5.7"
  instance_class        = "db.t2.micro"
  db_port               = "3306"
  db_name               = var.db_name
  db_user_passwd        = var.db_user_passwd
  security_groups       = [module.sg_web.sg_id]
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = data.aws_subnet_ids.private.ids
  license_model         = "general-public-license"
  parameter_group_name  = "default.mysql5.7"
}
```

```terraform
# create rds instance postgres

module db_postgres {
  source                = "./modules/rds_instance"
  name                  = "psgsql"
  availability_zone     = "${var.aws_region}a"
  project_name          = var.project_name
  engine                = "postgres"
  engine_version        = "11.6"
  instance_class        = "db.t2.micro"
  db_port               = "5432"
  db_name               = var.db_name
  db_user               = var.db_user
  db_user_passwd        = var.db_user_passwd
  security_groups       = [module.sg_web.sg_id]
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = data.aws_subnet_ids.private.ids
  license_model         = "postgresql-license"
  parameter_group_name  = "default.postgres11"
}
```

```terraform
module db_postgres {
  source                = "./modules/aws_rds_instance"
  name                  = "psgsql"
  availability_zone     = "${var.aws_region}a"
  project_name          = var.project_name
  engine                = "postgres"
  engine_version        = "11.6"
  instance_class        = "db.t2.micro"
  db_port               = "5432"
  db_name               = var.db_name
  db_user               = var.db_user
  db_user_passwd        = var.db_password
  security_groups       = [module.sg_web.sg_id]
  vpc_id                = module.vpc.vpc_id
  subnet_ids            = module.vpc.subnet_id
  license_model         = "postgresql-license"
  parameter_group_name  = "default.postgres11"
}
```
