terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

# S3
terraform {
  backend "s3" {
    bucket = "s3.terraform.project"
    key    = "state.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  profile = "default"
  region  = "eu-west-1"
  # region = "eu-central-1"
}

# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Terraform VPC"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id
}

# Subnet for VPC
data "aws_availability_zones" "available" {
  state = "available"
}
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.id
}

# resource "aws_subnet" "public_subnet" {
#   vpc_id            = aws_vpc.vpc.id
#   cidr_block        = "10.0.2.0/24"
#   availability_zone = "eu-west-1b"
# }

# Route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public.id
}

# Security group for ECS and RDS
resource "aws_security_group" "ecs_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG: ECS"
  }
}

resource "aws_security_group" "rds_sg" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.ecs_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "SG: RDS"
  }
}

# Autoscaling EC2
# IAM role for claster EC2
data "aws_iam_policy_document" "ecs_agent" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_agent" {
  name               = "ecs-agent"
  assume_role_policy = data.aws_iam_policy_document.ecs_agent.json
}

resource "aws_iam_role_policy_attachment" "ecs_agent" {
  role       = aws_iam_role.ecs_agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_agent" {
  name = "ecs-agent"
  role = aws_iam_role.ecs_agent.name
}

# Autoscaling from template
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_launch_configuration" "ecs_launch_config" {
  image_id             = data.aws_ami.ubuntu.id
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
  security_groups      = [aws_security_group.ecs_sg.id]
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=run_cluster >> /etc/ecs/ecs.config"
  instance_type        = "t2.micro"
  key_name             = "my_aws"
}

resource "aws_autoscaling_group" "failure_analysis_ecs_asg" {
  name                 = "asg"
  vpc_zone_identifier  = [aws_subnet.public_subnet.id]
  launch_configuration = aws_launch_configuration.ecs_launch_config.name

  desired_capacity          = 2
  min_size                  = 1
  max_size                  = 2
  health_check_grace_period = 300
  health_check_type         = "EC2"
}

# For DB
resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = [aws_subnet.public_subnet.id]
}

# DB
resource "aws_db_instance" "mysql" {
  identifier             = "mysql"
  multi_az               = false
  allocated_storage      = 5
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  name                   = "worker_db"
  username               = "worker"
  password               = "qwerty"
  port                   = "3306"
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.id
  vpc_security_group_ids = [aws_security_group.rds_sg.id, aws_security_group.ecs_sg.id]
  skip_final_snapshot    = false
  publicly_accessible    = true
}

# ECR
resource "aws_ecr_repository" "worker" {
  name = "worker"
}

# ECS
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "run_cluster"
}

resource "aws_ecs_task_definition" "task_definition" {
  family = "worker"
  container_definitions = jsonencode([
    {
      essential   = true
      memory      = 256
      name        = "worker"
      cpu         = 2
      image       = "921644664439.dkr.ecr.eu-west-1.amazonaws.com/worker:latest"
      environment = []
      portMappings = [
        {
          containerPort = 8080
          hostPort      = 0
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "worker_service" {
  name            = "worker_srv"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 2
}

