
# System Deployment manual

## Pre-requirements
 * Existing GCP project with billing account
 * Locally installed `terraform` and `gcloud`
 * Create `.env` file from `env.example` file

## Steps
* Configure GCP Project with initial configuration
  - Terraform control files are created in the `./terraform/json` folder, if don't have them, take from [Pandora](https://pandora.digicode.net/index.php/pwd/view_files/3096)
```bash
cd ./deploy/terraform/production
./scripts/01_init_project.sh
```

* Terraform Init
```bash
cd ./deploy/terraform/production
./scripts/02_tf_init.sh
```

* Terraform Plan
```bash
cd ./deploy/terraform/production
./scripts/03_tf_plan.sh
```

## Usage
* Apply Terraform configs
```bash
cd ./deploy/terraform/production
./scripts/04_tf_apply.sh
```

## Cleaning up if needed
```bash
cd ./deploy/terraform/production
./scripts/06_tf_destroy.sh
```

## SQL "read-only" user
* After Terraform has created the infrastructure and if want to make the user "read-only" in the DB, need to run the following commands in the current DB or take them in the file `history_read_only_user.sql`
```bash
-- Database 'Current_Database' add read-only user

CREATE USER 'USER'@'%' IDENTIFIED BY 'PASSWORD';
GRANT SELECT, SHOW VIEW ON *.* TO 'USER'@'%';
FLUSH PRIVILEGES;
```

## Deployment manifest
```bash
kubectl apply -f ./deploy/k8s/production/namespaces.yml
kubectl apply -f ./deploy/k8s/production/ingress/healthchecks_be.yaml --namespace=production
kubectl apply -f ./deploy/k8s/production/ingress/healthchecks_be_socketio.yaml --namespace=production
kubectl apply -f ./deploy/k8s/production/ingress/healthchecks_fe.yaml --namespace=production
kubectl apply -f ./deploy/k8s/production/ingress/healthchecks_game.yaml --namespace=production
kubectl apply -f ./deploy/k8s/production/ingress/redirect.yaml --namespace=production
kubectl apply -f ./deploy/k8s/production/ingress/certs.yaml --namespace=production
kubectl apply -f ./deploy/k8s/production/ingress/ingress.yaml
```

### configMapKeyRef
```bash
# Create
kubectl apply -f ./deploy/k8s/production/configmap.yml --namespace=production
# Delete
kubectl delete -f ./deploy/k8s/production/configmap.yml --namespace=production
```

#### Service account 
* File `key.json` for secret manager account

[Pandora](https://pandora.digicode.net/index.php/pwd/view_files/3122)

[Create new key in GCP](https://console.cloud.google.com/iam-admin/serviceaccounts/details/104030966894410749969?project=funtico-second-env&supportedpurview=project)

### secretKeyRef
```bash
# Create
kubectl create secret generic sm-key --from-file=key.json=key.json --namespace=production
kubectl create secret generic secrets-prod --from-env-file ./deploy/k8s/production/secrets-prod.properties --namespace=production

# Delete
kubectl delete secret sm-key --namespace=production
```
## Domain `gamefuntico.com`
[GCP Cloud DNS](https://console.cloud.google.com/net-services/dns/zones?project=winged-axon-353312&supportedpurview=project)

## RabbitMQ
* Need to set {USER} and {PASSWORD} in the file `rabbitmq.yml`
```bash
kubectl apply -f ./deploy/k8s/production/RabitMQ/rabbitmq.yml
```

#### Create Artefacts for RabbitMQ
  * Check if [Container Registry](https://console.cloud.google.com/gcr/images/funtico-second-env/global?project=funtico-second-env) got images, if not - create:
```bash
docker build -t gcr.io/funtico-second-env/rabbitmq.prod -f ./deploy/k8s/production/RabitMQ/Dockerfile .
docker push gcr.io/funtico-second-env/rabbitmq.prod:latest
```

### Hints
#### [gcloud install](https://cloud.google.com/sdk/docs/install#deb)
```bash
apt-get update && apt-get install -y apt-transport-https ca-certificates gnupg curl
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
apt-get update && apt-get install -y google-cloud-cli
```

#### [Terrafrom install](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)
```bash
apt-get update && apt-get install -y gnupg software-properties-common wget gpg
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
gpg --no-default-keyring --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg --fingerprint
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/hashicorp.list
apt update && apt-get install -y terraform
```
