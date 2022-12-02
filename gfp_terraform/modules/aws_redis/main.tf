data template_file redis_policy {
  template = file("${path.module}/files/redis_policy.json")
}

resource aws_iam_policy redis-policy {
  name        = "${var.project_name}-redis-policy"
  description = "Permission to the redis"
  policy      = data.template_file.redis_policy.rendered
}

resource aws_iam_role_policy_attachment ecs-tasks-attach-redis {
  role       = var.role
  policy_arn = aws_iam_policy.redis-policy.arn
}

resource aws_elasticache_replication_group redis {
  replication_group_id          = "${var.project_name}-redis"
  replication_group_description = "Replication group for Redis"
  automatic_failover_enabled    = true
  number_cache_clusters         = var.number_cache_clusters
  node_type                     = var.node_type
  engine_version                = var.engine_version
  parameter_group_name          = var.parameter_group_name
  subnet_group_name             = aws_elasticache_subnet_group.redis.name
  security_group_ids            = [aws_security_group.regis_sg.id]
  maintenance_window            = "thu:02:00-thu:03:00"
  port                          = "6379"
  tags = {
    Name    = "CacheReplicationGroup"
    Project = var.project_name
  }
}

resource aws_elasticache_subnet_group redis {
  name       = "${var.project_name}-cache-subnet"
  subnet_ids = var.subnet_ids
}

resource aws_security_group regis_sg {
  name        = "${var.project_name}-redis-sg"
  description = "Redis ${var.project_name} security group"
  vpc_id      = var.vpc_id
  ingress {
    from_port       = 6379
    to_port         = 6379
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
    Name = "${var.project_name}-redis-sg"
  }
  lifecycle {
    ignore_changes = [
      ingress,
      egress
    ]
  }
}

resource aws_security_group_rule regis_sg {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = aws_security_group.regis_sg.id
  security_group_id        = aws_security_group.regis_sg.id
}
