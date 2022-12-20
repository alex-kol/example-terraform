#!/usr/bin/env bash

source "${0%/*}/00_incl.sh"
echo -e "\n"

read -r -p "You're about to destroy all Resources of the Project ${project_id}. Are you sure? [y/N] " response

if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    echo_gray "Destroying All Resources of the Project ${project_id}"
    cd ./terraform
    terraform destroy -var-file=../.env
else
    echo_gray "Canceled"
fi
