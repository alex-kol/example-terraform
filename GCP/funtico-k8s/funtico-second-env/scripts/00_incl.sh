#!/usr/bin/env bash

# .env loading in the shell
dotenv () {
  set -a
  [ -f ../.env ] && . ../.env
  [ -f .env ] && . ./.env
  set +a
}

# Run dotenv on login
dotenv

set -x
gcloud config set project ${project_id}
gcloud config set filestore/zone ${zone}
gcloud config set compute/region ${region}
gcloud config set redis/region ${region}

source "${0%/*}/00_func_incl.sh"

echo_green "====> Project: ${project_id} <===="
