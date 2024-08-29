variable "bastion_host_sg_id" {
  description = "ID of the Security Group"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "subnet_id" {
  description = "Subnet id for bastion host"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for bastion host"
  type        = string
}