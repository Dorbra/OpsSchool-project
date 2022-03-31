variable "tags" {
  type = map(any)
}

variable "load_balancer_type" {
  type = string
}

variable "name" {
  type = string
}


variable "subnets" {
  type = list(string)
}

variable "security_groups" {
  type = list(string)
}

variable "internal" {
  type = bool
}
