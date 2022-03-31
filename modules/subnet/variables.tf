variable "cidr_block" {
  type = string
}

variable "tags" {
  type = map(any)
}

variable "vpc_id" {
  type = string
}

variable "map_public_ip_on_launch" {
  default = false
}

variable "availability_zone" {
  type = string
}
