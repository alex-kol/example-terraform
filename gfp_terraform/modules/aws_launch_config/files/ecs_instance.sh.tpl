#!/bin/bash

mkdir -p /etc/ecs

cat << EOF > /etc/ecs/ecs.config
ECS_CLUSTER=${cluster_name}
ECS_ENGINE_TASK_CLEANUP_WAIT_DURATION=5m
ECS_IMAGE_CLEANUP_INTERVAL=10m
ECS_AVAILABLE_LOGGING_DRIVERS=["json-file","awslogs"]
ECS_LOGFILE=/log/ecs-agent.log
EOF

