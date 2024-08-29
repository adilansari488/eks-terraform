variable "name" {
  description = "Name of the Security Group"
  type        = string
}

variable "description" {
  description = "Description of the Security Group"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "ingress_from_port" {
  description = "Inbound from port"
  type        = string
}

variable "ingress_to_port" {
  description = "Inbound to port"
  type        = string
}

variable "cidr_blocks" {
  description = "CIDR range for inbound rules"
  type        = list(string)
}
