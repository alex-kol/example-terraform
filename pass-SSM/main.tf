provider "aws" {
  region = "eu-west-1"
}

# выбираем параметры для пароля - длину, спец символы
resource "random_string" "rds_password" {
  length           = 12
  special          = true
  override_special = "!#$&"
}

# генерация пароля
resource "aws_ssm_parameter" "rds_password" {
  name        = "/prod/mysql"
  description = "Master password for RDS"
  type        = "SecureString"
  # value       = "mypassword"
  value = random_string.rds_password.result
}

# сохраняем в Parameter store
data "aws_ssm_parameter" "my_rds_pass" {
  name = "/prod/mysql"
  depends_on = [
    aws_ssm_parameter.rds_password
  ]
}

output "rds_password" {
  value = data.aws_ssm_parameter.my_rds_pass.value
  sensitive   = true
}

# Используем сгенерированый пароль
resource "aws_db_instance" "default" {
  identifier           = "prod-rds"
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "prod"
  username             = "admin"
  password             = data.aws_ssm_parameter.my_rds_pass.value
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true
  apply_immediately    = true
}

