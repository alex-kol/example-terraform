
# Arcadia System Deployment manual

## Pre-requirements
 * Existing GCP project with billing account
 * Locally installed terraform and gcloud 
 * Fulfill deployment/production/scripts/.env file from example deployment/production/scripts/.env.example or for modification download it from the GCP bucket with name tf-arcadia-state-production
 * Store deployment/production/scripts/.env to the GCP bucket with name tf-arcadia-state-production(should exist already)
 * Interconnect attachment/VPC peering should be added manually because of setting should be verified with other side
 * Installed mysql-client
 * Generate mongodb certificate for replicaset communication. 
    ```shell
    openssl rand -base64 700 > mongo_rs.key
    ```


## Steps
* Configure GCP Project with initial configuration

```console
$ ./scripts/01_init.sh
```

* Terraform Init
```console
$ ./scripts/02_tf_init.sh
```

# Usage
* Apply terraform configs

```console
$ ./scripts/03_tf_apply.sh
```

## Cleaning Up If needed
Infrastructure
  ```console
  $ ./scripts/10_tf_destroy.sh
  ```

# GKE Cluster
  ```console
  $ ./scripts/05_gke_init.sh
  ```


## MongoDB Backup

### Backup means restore ^^

## Cleaning up
