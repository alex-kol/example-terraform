#!/usr/bin/env bash

source "${0%/*}/00_incl.sh"

cd ./terraform

terraform init -reconfigure -backend-config="bucket=${tf_state_bucket_name}-tf"
