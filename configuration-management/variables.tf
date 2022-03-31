terraform {
  required_version = ">= 0.13.5"
}

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "vpc_id" {
  description = "AWS VPC id"

}

variable "subnet_id" {
  description = "Ansible Subnet id"

}

variable "ingress_ports" {
  type        = list(number)
  description = "list of ingress ports"
  default     = [22, 8080]
}
