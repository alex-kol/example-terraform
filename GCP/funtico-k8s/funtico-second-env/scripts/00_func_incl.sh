#!/usr/bin/env bash

export credential_path="./terraform/json/tf_service_account.json"
export sm_credentials_path="./terraform/json/sm_service_account.json"

sed_replace(){
    echo $(sed -e 's/[&\\/]/\\&/g; s/$/\\/' -e '$s/\\$//' <<<"$1")
}

echo_darkgray() {
    echo -e "\033[90m$1\033[0m"
}

echo_gray() {
    echo -e "\033[91m$1\033[0m"
}

echo_red() {
    echo -e "\033[31m$1\033[0m"
}

echo_green() {
    echo -e "\033[92m$1\033[0m"
}

parse_json_val() {
    KEY=$1
    num=$2
    awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'${KEY}'\042/){print $(i+1)}}}' | tr -d '"' | sed -n ${num}p
}

get_secret() {
    local key=${1:-}
    local value=$(gcloud beta secrets versions access latest --secret="${key}" 2>&1 |grep -v "NOT_FOUND" |grep -v "secretmanager.googleapis.com")
    if [ -z "${value}" ]
    then
        echo_red "ERROR: Google Secret manager does not have value for the variable -${key}-"
    else
        echo ${value}
    fi
}
