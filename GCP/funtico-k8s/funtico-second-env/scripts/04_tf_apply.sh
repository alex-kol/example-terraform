#!/usr/bin/env bash

source "${0%/*}/00_incl.sh"

cd ./terraform

terraform apply -var-file=../.env
