output cluster_name {
  description = "Cluster name"
  value       = aws_ecs_cluster.cluster.name
}

output cluster_id {
  description = "ID cluster"
  value       = aws_ecs_cluster.cluster.id
}

output cluster_arn {
  description = "Cluster arn"
  value       = aws_ecs_cluster.cluster.arn
}
