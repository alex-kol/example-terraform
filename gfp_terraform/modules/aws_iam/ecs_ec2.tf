data aws_iam_policy_document ecs_tasks {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource aws_iam_role ecs_tasks {
  name               = "${var.name}-ecs-tasks"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks.json
  tags = {
    Environment = var.environment
  }
}

data template_file ecs_task_policy {
  template = file("${path.module}/files/ecs_tasks_policy.json")
}

resource aws_iam_policy ecs_tasks_policy {
  name        = "${var.name}-ecs-tasks-policy"
  description = "Full permission to the repository"
  policy      = data.template_file.ecs_task_policy.rendered
}

resource aws_iam_role_policy_attachment ecs-tasks-attach {
  role       = aws_iam_role.ecs_tasks.name
  policy_arn = aws_iam_policy.ecs_tasks_policy.arn
}

data template_file ecs_instance_policy {
  template = file("${path.module}/files/ecs_instance_policy.json")
}

resource aws_iam_role ecs_instance {
  name               = "${var.name}-ecs-instance"
  assume_role_policy = data.template_file.ecs_instance_policy.rendered
  tags = {
    Environment = var.environment
  }
}

resource aws_iam_instance_profile ecs_instance {
  name = "${var.name}-ecs-instance-profile"
  role = aws_iam_role.ecs_instance.name
  path = "/"
}

resource aws_iam_role_policy_attachment ecs_rights {
  role       = aws_iam_role.ecs_instance.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

data template_file sas_policy {
  template = file("${path.module}/files/sas_policy.json")
}

resource aws_iam_policy service_auto_scaling {
  name        = "${var.name}-service-auto-scaling"
  description = "ECS ${var.name} service auto scaling"
  policy      = data.template_file.sas_policy.rendered
}

resource aws_iam_role_policy_attachment service_auto_scaling {
  role       = aws_iam_role.ecs_tasks.name
  policy_arn = aws_iam_policy.service_auto_scaling.arn
}
