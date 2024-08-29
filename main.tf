provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./vpc"
  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zones
  private_subnets     = var.private_subnets
  public_subnets      = var.public_subnets
  cluster_name        = var.cluster_name
}

# module "eks" {
#   source = "./eks" 
  
#   cluster_name    = var.cluster_name
#   vpc_id          = module.vpc.vpc_id
#   private_subnets = module.vpc.private_subnets
# }

# module "autoscaling" {
#   source = "./autoscaling"
  
#   cluster_name    = module.eks.cluster_name
#   vpc_id          = module.vpc.vpc_id
#   private_subnets = module.vpc.private_subnets
# }

module "bastion" {
  source              = "./bastion"

  ami_id              = "ami-05134c8ef96964280"
  # cluster_name        = module.eks.cluster_name
  cluster_name        = "test"
  bastion_host_sg_id  = module.bastion_security.sg_id
  subnet_id           = element(module.vpc.public_subnets, 0)
} 

module "bastion_security" {
  source          = "./security"
  
  vpc_id          = module.vpc.vpc_id
  name            = var.bastion_sg_name
  description     = var.bastion_sg_desc
  ingress_from_port = 22
  ingress_to_port   = 22
  cidr_blocks         = ["${local.workstation_external_cidr}"]
}

data "http" "workstation_external_ip" {
  url = "http://ipv4.icanhazip.com"
}

locals {
  workstation_external_cidr = "${chomp(data.http.workstation_external_ip.response_body)}/32"
}
