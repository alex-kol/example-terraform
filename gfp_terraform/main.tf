resource aws_key_pair ecs_key {
  key_name   = local.prefix
  public_key = var.aws_key_pair
}

# IAM configure

module iam {
  source      = "./modules/aws_iam"
  name        = local.prefix
  environment = var.environment
}

# Create VPC

module vpc {
  source       = "./modules/aws_vpc"
  name         = local.prefix
  environment  = var.environment
  cidr_network = lookup(var.cidr_network, var.environment)
}

#############################
#         bastion           #
#############################

# create security group for bastion
module sg_bastion {
  source       = "./modules/aws_sg"
  name         = "${local.prefix}-bastion"
  vpc_id       = module.vpc.vpc_id
  ingress_data = local.permission_bastion
}

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

#############################
#         web               #
#############################

# create security group for web
module sg_web {
  source       = "./modules/aws_sg"
  name         = "${local.prefix}-web"
  vpc_id       = module.vpc.vpc_id
  ingress_data = local.permission_web
}

#############################
#          redis            #
#############################

module redis {
  source                = "./modules/aws_redis"
  project_name          = local.prefix
  role                  = module.iam.ecs_task_role_name
  subnet_ids            = module.vpc.subnet_id
  vpc_id                = module.vpc.vpc_id
  security_groups       = [module.sg_web.sg_id]
  number_cache_clusters = lookup(var.redis_number_cache_clusters, var.environment)
  node_type             = lookup(var.redis_node_type, var.environment)
}

#############################
#            RDS            #
#############################


module db_postgres {
  source                = "./modules/aws_rds_instance"
  name                  = "psgsql"
  availability_zone     = "${var.aws_region}a"
  project_name          = var.project_name
  engine                = "postgres"
  engine_version        = "11.9"
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


#############################
#      Launch_config        #
#############################

module launch_config_ecs {
  source                      = "./modules/aws_launch_config"
  name                        = local.prefix
  image_id                    = data.aws_ami.amazon-ami.id
  instance_type               = lookup(var.instance_type, var.environment)
  iam_instance_profile        = module.iam.instance_profile_name
  key_name                    = aws_key_pair.ecs_key.key_name
  associate_public_ip_address = false
  spot_price                  = var.spot_price
  security_groups             = [module.sg_web.sg_id]
  volume_type                 = "io1"
  volume_size                 = "30"
  iops                        = "500"
}

#############################
#            ASG            #
#############################

module asg {
  source               = "./modules/aws_asg"
  vpc_zone_identifier  = module.vpc.subnet_id
  name                 = local.prefix
  min_size             = lookup(var.ecs_instance_min_size, var.environment)
  desired_capacity     = lookup(var.ecs_instance_min_size, var.environment)
  max_size             = lookup(var.ecs_instance_max_size, var.environment)
  launch_configuration = module.launch_config_ecs.instance
  adjustment_type      = "ChangeInCapacity"
}

################################
#              ECS             #
################################

module ecs {
  source      = "./modules/aws_ecs"
  name        = local.prefix
}

################################
#             ECR              #
################################

module ecr_web {
  source  = "./modules/aws_ecr"
  name    = "${local.prefix}-web"
}
