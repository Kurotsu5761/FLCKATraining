# Terraform to setup VMs on Azure
This project aims to setup/destroy VMs on Azure that will be used for Foundation Linux K8s training

## Run terraform with .env file

### Initialization with .env file
docker run --env-file ./.env --rm -it -v ${PWD}:/workspace -w /workspace zenika/terraform-azure-cli:latest init

### Plan the configuration files
docker run --env-file ./.env --rm -it -v ${PWD}:/workspace -w /workspace zenika/terraform-azure-cli:latest plan -out tf.plan

### Apply the configuration files
docker run --env-file ./.env --rm -it -v ${PWD}:/workspace -w /workspace zenika/terraform-azure-cli:latest terraform apply

### Destroy all the components
docker run --env-file ./.env --rm -it -v ${PWD}:/workspace -w /workspace zenika/terraform-azure-cli:latest terraform destroy -auto-approve