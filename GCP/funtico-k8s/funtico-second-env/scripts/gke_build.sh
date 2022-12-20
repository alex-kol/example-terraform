#!/bin/bash
source "${0%/*}/00_incl.sh"

#building images for gke workloads
echo_green "Building images"
gcloud beta builds triggers run --branch=master arcadia-voucher-portal && sleep 2 && \
gcloud beta builds triggers run --branch=master backoffice-api-production && sleep 2 && \
gcloud beta builds triggers run --branch=master backoffice-fe-production && sleep 2 && \
gcloud beta builds triggers run --branch=master client-api-production && sleep 2 && \
gcloud beta builds triggers run --branch=master client-fe-production && sleep 2 && \
gcloud beta builds triggers run --branch=master game-core-api-production && sleep 2 && \
gcloud beta builds triggers run --branch=master game-core-worker-production && sleep 2 && \
gcloud beta builds triggers run --branch=master migration-audit-production && sleep 2 && \
gcloud beta builds triggers run --branch=master migration-main-production && sleep 2 && \
gcloud beta builds triggers run --branch=master monitoring-api-production && sleep 2 && \
gcloud beta builds triggers run --branch=master monitoring-worker-production && sleep 2 && \
gcloud beta builds triggers run --branch=master operator-factory-production && sleep 2 && \
gcloud beta builds triggers run --branch=master socket-node-production
echo_green "Building completed"

