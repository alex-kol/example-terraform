output instances {
  description = "IDs of instances found through the filter"
  value       = data.aws_instances.ecs.ids
}

output instance_name {
  description = "The name instance"
  value       = aws_autoscaling_group.ecs_instances.name
  sensitive   = false
  depends_on  = [
    aws_autoscaling_group.ecs_instances
  ]
}

output asg_arn {
  description = "The ARN autoscaling group"
  value       = aws_autoscaling_group.ecs_instances.arn
  sensitive   = false
  depends_on  = [
    
  ]
}