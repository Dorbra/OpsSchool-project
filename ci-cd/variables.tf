variable "key_name" {
  type    = string
  default = "jenkins_ec2_key"
}

variable "master_subnet" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "agents_subnet" {
  type = string
}

variable "default_sg" {
  type = string

}

variable "consul_version" {
  type        = string
  description = "consul version"
  default     = "1.8.5"
}

variable "consul_dc_name" {
  type        = string
  description = "consul datacenter name"
  default     = "dorbra"
}

variable "consul_server_name" {
  type        = string
  description = "consul server name"
  default     = "consul-server"
}

variable "consul_agent_name" {
  type        = string
  description = "consul agent name"
  default     = "consul-agent"
}

variable "consul_security_group_id" {
  description = "security group of consul"
  type        = string
}

variable "prometheus_dir" {
  description = "directory for prometheus binaries"
  default     = "/opt/prometheus"
}

variable "node_exporter_version" {
  description = "Node Exporter version"
  default     = "0.18.1"
}

