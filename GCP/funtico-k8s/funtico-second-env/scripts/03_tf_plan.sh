#!/usr/bin/env bash

source "${0%/*}/00_incl.sh"

cd ./terraform

terraform plan -var-file=../.env
