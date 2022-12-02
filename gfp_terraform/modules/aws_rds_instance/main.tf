resource aws_db_instance default {
  apply_immediately          = false
  auto_minor_version_upgrade = true
  availability_zone          = var.availability_zone
  db_subnet_group_name       = aws_db_subnet_group.default.id
  vpc_security_group_ids     = [aws_security_group.rds_sg.id]
  publicly_accessible        = true
  backup_retention_period    = 1
  backup_window              = "23:15-23:45"
  copy_tags_to_snapshot      = true
  deletion_protection        = false
  engine                     = var.engine
  engine_version             = var.engine_version
  identifier                 = "${var.project_name}-${var.name}"
  instance_class             = var.instance_class
  license_model              = var.license_model
  max_allocated_storage      = 20
  name                       = var.db_name
  password                   = var.db_user_passwd
  skip_final_snapshot        = var.skip_final_snapshot
  storage_type               = "gp2"
  allocated_storage          = var.allocated_storage
  storage_encrypted          = false
  username                   = var.db_user
  parameter_group_name       = var.parameter_group_name
}

resource aws_db_subnet_group default {
  name       = "${var.project_name}-${var.name}"
  subnet_ids = var.subnet_ids
  tags = {
    Name = "${var.project_name}-${var.name}-group"
  }
}

resource aws_security_group rds_sg {
  name        = "${var.project_name}-${var.name}-sg"
  description = "RDS ${var.project_name} ${var.name} security group"
  vpc_id      = var.vpc_id
  ingress {
    from_port       = var.db_port
    to_port         = var.db_port
    protocol        = "tcp"
    security_groups = var.security_groups
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}

resource aws_security_group_rule rds {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.rds_sg.id
  security_group_id        = aws_security_group.rds_sg.id
}
