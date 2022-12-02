resource aws_autoscaling_group ecs_instances {
  lifecycle { create_before_destroy = true }
  vpc_zone_identifier  = var.vpc_zone_identifier
  name                 = "${var.name}-ecs-asg"
  min_size             = var.min_size
  desired_capacity     = var.desired_capacity
  max_size             = var.max_size
  force_delete         = true
  health_check_type    = "EC2"
  launch_configuration = var.launch_configuration
  termination_policies = ["OldestLaunchConfiguration"]
  enabled_metrics      = [
    "GroupDesiredCapacity",
    "GroupInServiceCapacity",
    "GroupPendingCapacity",
    "GroupMinSize",
    "GroupMaxSize",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupStandbyCapacity",
    "GroupTerminatingCapacity",
    "GroupTerminatingInstances",
    "GroupTotalCapacity",
    "GroupTotalInstances"
  ]
  tag {
    key                 = "Name"
    value               = "${var.name}-ecs"
    propagate_at_launch = true
  }
}

resource aws_autoscaling_policy scale_up {
  name                   = "${var.name}-asg-scale_up"
  scaling_adjustment     = 1
  adjustment_type        = var.adjustment_type
  cooldown               = 50
  autoscaling_group_name = aws_autoscaling_group.ecs_instances.name
}

resource aws_autoscaling_policy up_memory {
  name                   = "${var.name}-asg-scale_memory_up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 50
  autoscaling_group_name = aws_autoscaling_group.ecs_instances.name
}

# resource aws_cloudwatch_metric_alarm scale_up_alarm {
#   alarm_name                = "${var.name}-high-asg-cpu"
#   comparison_operator       = "GreaterThanThreshold"
#   evaluation_periods        = "1"
#   metric_name               = "CPUUtilization"
#   namespace                 = "AWS/EC2"
#   period                    = "120"
#   statistic                 = "Average"
#   threshold                 = "90"
#   insufficient_data_actions = []
#   dimensions = {
#     ClusterName = var.name
#   }
#   alarm_actions     = [aws_autoscaling_policy.up_memory.arn]
# }

resource aws_cloudwatch_metric_alarm memory_high {
  alarm_name                = "${var.name}-high-asg-memory"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "MemoryReservation"
  namespace                 = "AWS/ECS"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "90"
  alarm_description         = "This metric monitors ec2 memory for high utilization on agent hosts"
  insufficient_data_actions = []
  dimensions = {
    ClusterName = var.name
  }
  alarm_actions     = [aws_autoscaling_policy.up_memory.arn]
}

resource aws_autoscaling_policy memory_scale_down {
    name                    = "${var.name}-asg-scale_memory_down"
    scaling_adjustment      = -1
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    autoscaling_group_name  = aws_autoscaling_group.ecs_instances.name
}

resource aws_cloudwatch_metric_alarm memory-low {
    alarm_name          = "${var.name}-mem-util-low-agents"
    comparison_operator = "LessThanOrEqualToThreshold"
    evaluation_periods  = "2"
    metric_name         = "MemoryReservation"
    namespace           = "AWS/ECS"
    period              = "300"
    statistic           = "Average"
    threshold           = "10"
    alarm_description   = "This metric monitors ec2 memory for low utilization on agent hosts"
    alarm_actions       = [aws_autoscaling_policy.memory_scale_down.arn]
    dimensions = {
      ClusterName = var.name
    }
}

resource aws_autoscaling_policy scale_down {
  name                   = "${var.name}_scale_down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.ecs_instances.name
}

resource aws_cloudwatch_metric_alarm scale_down_alarm {
  alarm_name                = "${var.name}-low-asg-cpu"
  comparison_operator       = "LessThanThreshold"
  evaluation_periods        = "3"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "15"
  insufficient_data_actions = []
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ecs_instances.name
  }
  alarm_description = "EC2 CPU Utilization"
  alarm_actions     = [aws_autoscaling_policy.scale_down.arn]
}

resource aws_cloudwatch_metric_alarm cpu_up_alarm {
  alarm_name                = "${var.name}-hith-cpu"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "60"
  statistic                 = "Average"
  threshold                 = "50"
  insufficient_data_actions = []
  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.ecs_instances.name
  }
  alarm_description = "EC2 hith CPU Utilization"
  alarm_actions     = [
    aws_autoscaling_policy.scale_up.arn
  ]
}


data aws_instances ecs {

  instance_tags = {
    Name = "${var.name}-ecs"
  }

  instance_state_names = ["running", "stopped"]
  # instance_state_names = ["running", "stopped", "terminated"]

  depends_on = [aws_autoscaling_group.ecs_instances]
}
