# Thegoodfaceproject Terraform AWS

## Terraform version

- 1.0.7

## Configuration Variables for Terraform Cloud

- environment = dev
- aws_access_key
- aws_secret_key
- aws_region
- aws_key_pair
- data_ssh

## Usage

### Initializing Terraform

```bash
terraform init
```

### Running Terraform

Run the following to ensure terraform will only perform the expected actions:

```bash
terraform plan
```

Run the following to apply the configuration to the target AWS environment:

```bash
terraform apply
```

### Tearing Down the Terraformed Cluster

Run the following to verify that terraform will only impact the expected nodes and then tear down the cluster.

```bash
terraform plan
terraform destroy
```
