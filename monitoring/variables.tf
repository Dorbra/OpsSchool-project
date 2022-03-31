variable "region" {
  description = "AWS region for VMs"
  default     = "us-east-1"
}

variable "servers" {
  description = "The number of consul servers."
  default     = 3
}

variable "clients" {
  description = "The number of consul client instances"
  default     = 1
}

variable "consul_version" {
  description = "The version of Consul to install (server and client)."
  default     = "1.4.0"
}

variable "key_name" {
  description = "name of ssh key to attach to hosts"
  default     = "monitoring"
}

variable "ami" {
  description = "ami to use - based on region"
  default = {
    "us-east-1" = "ami-04b9e92b5572fa0d1"
    "us-east-2" = "ami-0d5d9d301c853a04a"
  }
}

variable "prometheus_dir" {
  description = "directory for prometheus binaries"
  default     = "/opt/prometheus"
}

variable "prometheus_conf_dir" {
  description = "directory for prometheus configuration"
  default     = "/etc/prometheus"
}

variable "promcol_version" {
  description = "Prometheus Collector version"
  default     = "2.16.0"
}

variable "node_exporter_version" {
  description = "Node Exporter version"
  default     = "0.18.1"
}

variable "apache_exporter_version" {
  description = "Apache Exporter version"
  default     = "0.7.0"
}

variable "vpc_id" {
  type = string
}

variable "subnet_id" {
  type = list(string)
}

variable "public_subnet" {
  type = string
}

# variable "grafana_version" {
#   default = "8.4.3"
# }
