# Terraform to setup VMs on Azure
This project aims to setup/destroy VMs on Azure that will be used for Foundation Linux K8s training

## Prerequisite
### Azure Tenant
You'll need to have an Azure Tenant for this project. Sign up at https://azure.microsoft.com/en-in/free/

Create a [subscription](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/create-subscription) and a [service principal](https://learn.microsoft.com/en-us/azure/devops/integrate/get-started/authentication/service-principal-managed-identity?view=azure-devops)
Assign **Owner** role to the service principal in your created subscription

### Docker
Do install docker as this project uses docker run of terraform

### Additional Files needed
**.env**
ARM_CLIENT_ID=
ARM_CLIENT_SECRET=
ARM_TENANT_ID=
ARM_SUBSCRIPTION_ID=

## Commands
### Initialization with .env file
docker run --env-file ./.env --rm -it -v ${PWD}:/workspace -w /workspace hashicorp/terraform:latest init

### Plan the configuration files
docker run --env-file ./.env --rm -it -v ${PWD}:/workspace -w /workspace zenika/terraform-azure-cli:latest terraform plan -out tf.plan

### Apply the configuration files
docker run --env-file ./.env --rm -it -v ${PWD}:/workspace -w /workspace zenika/terraform-azure-cli:latest terraform apply

### Destroy all the components
docker run --env-file ./.env --rm -it -v ${PWD}:/workspace -w /workspace zenika/terraform-azure-cli:latest terraform destroy -auto-approve