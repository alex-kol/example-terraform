#!/usr/bin/env bash

source "${0%/*}/00_incl.sh"

#
# Configure GCP according to Project Needs
#

#Enable GCP APIs
gcloud services enable containerregistry.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable servicenetworking.googleapis.com
gcloud services enable cloudbuild.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable vpcaccess.googleapis.com
gcloud services enable container.googleapis.com
gcloud services enable sql-component.googleapis.com
gcloud services enable sqladmin.googleapis.com

gcloud beta services enable redis.googleapis.com
gcloud beta services enable secretmanager.googleapis.com

#
##Create Terraform Service Account and Store JSON Credentials in secure place
gcloud iam service-accounts create terraform \
  --display-name "Terraform admin account"

gcloud iam service-accounts keys create ${credential_path} \
  --iam-account terraform@${project_id}.iam.gserviceaccount.com

#Grant Relevant Permissions to Service Account(to be keeped up-to-date)
#https://cloud.google.com/iam/docs/understanding-roles
gcloud projects add-iam-policy-binding ${project_id} \
  --member serviceAccount:terraform@${project_id}.iam.gserviceaccount.com \
  --role roles/viewer

gcloud projects add-iam-policy-binding ${project_id} \
  --member serviceAccount:terraform@${project_id}.iam.gserviceaccount.com \
  --role roles/storage.admin

gcloud projects add-iam-policy-binding ${project_id} \
  --member serviceAccount:terraform@${project_id}.iam.gserviceaccount.com \
  --role roles/compute.networkAdmin

gcloud projects add-iam-policy-binding ${project_id} \
  --member serviceAccount:terraform@${project_id}.iam.gserviceaccount.com \
  --role roles/compute.admin

gcloud projects add-iam-policy-binding ${project_id} \
    --member serviceAccount:terraform@${project_id}.iam.gserviceaccount.com \
    --role roles/redis.admin

gcloud projects add-iam-policy-binding ${project_id} \
    --member serviceAccount:terraform@${project_id}.iam.gserviceaccount.com \
    --role roles/vpcaccess.admin

gcloud projects add-iam-policy-binding ${project_id} \
    --member serviceAccount:terraform@${project_id}.iam.gserviceaccount.com \
    --role roles/secretmanager.admin

gcloud projects add-iam-policy-binding ${project_id} \
    --member serviceAccount:terraform@${project_id}.iam.gserviceaccount.com \
    --role roles/iam.serviceAccountUser

gcloud projects add-iam-policy-binding ${project_id} \
    --member serviceAccount:terraform@${project_id}.iam.gserviceaccount.com \
    --role roles/iam.securityAdmin

gcloud projects add-iam-policy-binding ${project_id} \
    --member serviceAccount:terraform@${project_id}.iam.gserviceaccount.com \
    --role roles/container.admin

gcloud projects add-iam-policy-binding ${project_id} \
    --member serviceAccount:terraform@${project_id}.iam.gserviceaccount.com \
    --role roles/cloudsql.admin

gcloud projects add-iam-policy-binding ${project_id} \
    --member serviceAccount:terraform@${project_id}.iam.gserviceaccount.com \
    --role roles/cloudbuild.builds.editor

gcloud projects add-iam-policy-binding ${project_id} \
    --member serviceAccount:terraform@${project_id}.iam.gserviceaccount.com \
    --role roles/logging.admin

#for SM only
gcloud iam service-accounts create sm-manager \
  --display-name "secret manager account"

gcloud iam service-accounts keys create ${sm_credentials_path} \
  --iam-account sm-manager@${project_id}.iam.gserviceaccount.com

gcloud projects add-iam-policy-binding ${project_id} \
    --member serviceAccount:sm-manager@${project_id}.iam.gserviceaccount.com \
    --role roles/secretmanager.secretAccessor

#CloudBuild
PROJECT_NUM=$(gcloud projects list --filter="${project_id}" --format="value(PROJECT_NUMBER)" --project=${project_id})
gcloud projects add-iam-policy-binding ${project_id} \
     --member=serviceAccount:${PROJECT_NUM}@cloudbuild.gserviceaccount.com \
     --role=roles/container.developer

gcloud projects add-iam-policy-binding ${project_id} \
     --member=serviceAccount:${PROJECT_NUM}@cloudbuild.gserviceaccount.com \
     --role=roles/cloudsql.client

gcloud projects add-iam-policy-binding ${project_id} \
     --member=serviceAccount:${PROJECT_NUM}@cloudbuild.gserviceaccount.com \
     --role=roles/secretmanager.admin

# while true; do
#     read -p "Please connect now Cloud Build with the repository https://bitbucket.org/caesarea/arcadia-dev/src/master/, type ok when done " ok
#     if [ "$ok" = "ok" ]; then
# 	    echo "Thanks" && break
#     fi
# done

#GCStorage for the Terraform states
gsutil mb -p ${project_id} gs://${tf_state_bucket_name}-tf
gsutil versioning set on gs://${tf_state_bucket_name}-tf

cat > ./terraform/backend.tf << EOF
terraform {
 backend "gcs" {
  bucket  = "${tf_state_bucket_name}-tf"
  prefix  = "env/${env_name}"
  credentials = "./json/tf_service_account.json"
 }
}
EOF

echo_red   "\nPlease keep 'GOOGLE_APPLICATION_CREDENTIALS' in secure storage, as this file must be ignored by GIT"
echo_green "\n===================\nDone. Please double check output to be sure no errors occurred"
exit

#automatic snapshots schedule
# gcloud compute resource-policies create snapshot-schedule backup --project=${project_id} --region={region} --max-retention-days=14 --on-source-disk-delete=apply-retention-policy --daily-schedule --start-time=3:00 --storage-location={region}

#ssl certs
# gcloud compute ssl-certificates create funtico-io --description=arcadiagaming.io --domains=${game} --domains=${bo} --domains=${socketio} --domains=${voucher} --global
