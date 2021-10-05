# nca
NordCloud Assignment

## Intro
This repo contains assets for multi-regional, highly-available, scalable and secure [ghost](https://docs.ghost.org) deployment.

# TL;DR
[terraform.tfvars](./tf/terraform.tfvars): **edit before deployment**
```bash
$ cd ./tf
$ terraform init
$ terraform plan
$ terraform apply
$ Plan: 38 to add, 0 to change, 0 to destroy.
$ Do you want to perform these actions?
$ Terraform will perform the actions described above.
$ Only 'yes' will be accepted to approve.
$
$  Enter a value:
$ "yes"
$ Apply complete! Resources: 38 added, 0 changed, 0 destroyed.
```

## Table of Contents
- [Architecture overview](./NCA-HA-Architecture.pdf) : Overview of NCA deployment
- [Architecture Visio draft](./NCA-HA.vsdx)
- [Terraform Base](./tf/) : Base module for NCA deployment
- [ResourceGroup Module](./tf/rg/) : Azure ResourceGroup Deployment for Web - DB - Security
- [Database Module](./tf/db/) : Azure Database for MySQL
- [Storage Module](./tf/storage/) : Azure Storage Account, Container, FileShare, BlobContent, SASUri deployment
- [Ghost Purger](./tf/storage/artifacts/) : Deployed as a blob by Storage Module, consumed by WebModule for functionApp
- [KeyVault Module](./tf/vault/) : Azure KeyVault Service for MySQL credentials
- [Web Module](./tf/web/) : App Service Plan, Web App for Containers, FunctionApp deployment
- [Web Application Firewall](./tf/waf/) : Global Azure FrontDoor deployment with AppService backend
- [Terraform Variables](./tf/terraform.tfvars) : Default values for NCA deployment

### Prerequisities
- You need to have an active Azure Subscription. ([Try for free](https://azure.microsoft.com/en-us/free/))
- [Azure-cli](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Terraform-cli](https://www.terraform.io/docs/cli/index.html)


Terraform modules are tested with tooling defined below:
- Terraform v1.0.7 on windows_amd64
-  provider registry.terraform.io/hashicorp/azurerm v2.78.0

- azure-cli                         2.28.0
- core                              2.28.0
- telemetry                          1.0.6
- Python (Windows) 3.8.9 (tags/v3.8.9:a743f81, Apr  6 2021, 13:22:56) [MSC v.1928 32 bit (Intel)]

### List of Deployed all (38) Azure Infrastructure resources
- 7x ResourceGroups (2x Web, 2x DB, 2x Security, 1x Global)
- 2x User Assigned Identities
- 2x Application Insights workspaces
- 2x Azure KeyVaults
- 1x Azure Storage Account
- 1x Azure Files Share (ghost)
- 1x Azure Container (pub)
- 1x Azure Blob (ghost-function.zip) : 1x Shared Access Signature
- 1x Azure MySQL Database Servers : 1x Azure Database for MySQL
- 2x Linux App Service Plans : 2x Autoscale profiles
- 2x Web App for Containers (docker/ghost:alpine-4.16.0)
- 2x FunctionApp (ghost-function.zip)

### How to scale down/up base resources
- [AppServicePlan](./tf/web/main.tf#L19)
- [MySQL Server](./tf/db/main.tf#L17)
- [Azure Files Share Quota](./tf/storage/main.tf#L27)
