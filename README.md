# EKS-Terraform

Hello folks, this gihub repository contains the terrafom code to setup an EKS cluster with all its dependancies. It will setup the EKS cluster in private subnets and a bastion host in a public subnet to access that EKS cluster.

## Prerequisite

- Must have sufficient privileges to create, manage and delete resource on AWS.
- Should posses basic familiarity of terraform.

## How to use

Clone this repository and change directory to eks-terraform:

```bash
git clone https://github.com/adilansari488/eks-terraform.git
```

```bash
cd eks-terraform
```

Update variables in variables.tf file as per your requirements and run following:

```bash
terraform plan
```

```bash
terraform apply
```

Wait for resource creation. *(It may take 10-20 minutes to create all the resources.)*

## Manual steps after resource creations *(Need to automate in later versions of the program/code)*

- Take private IP or Security Group ID of the bastion host and add it to inbound rules of EKS Cluster Security group to allow network access from bastion host.
- Go to Access tab of EKS and create an entry for the bastion host role with EksAdminPolicy and EksClusterAdminPolicy to allow EKS resource access from bastion host.

## Contribution

If you like to contribute to this repository and enhance current code/configuration, Feel free to fork this repo, create a new branch, make your changes and raise a pull request to get it merged.
If you find any bugs or issues with the code, feel free to raise the issue with github issues feature.

