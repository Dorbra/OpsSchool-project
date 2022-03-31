variable "cidr_block" {
  type = string
}

variable "tags" {
  type = map(any)
}

variable "instance_tenancy" {
  type    = string
  default = "default"
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}
