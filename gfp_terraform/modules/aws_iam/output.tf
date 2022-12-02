output ecs_task_arn {
  description = "ARN ecs task"
  value       = aws_iam_role.ecs_tasks.arn
  sensitive   = false
}

output ecs_task_role_name {
  description = "ECS task role name"
  value       = aws_iam_role.ecs_tasks.name
  sensitive   = false
}

output instance_profile_name {
  description = "The name profile for instance"
  value       = aws_iam_instance_profile.ecs_instance.name
  sensitive   = false
}
