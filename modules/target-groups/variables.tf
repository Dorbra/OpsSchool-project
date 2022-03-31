variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "port" {
  type = number
}

variable "protocol" {
  type = string
}


variable "target_type" {
  type    = string
  default = "instance"
}

variable "health_check_path" {
  type = string
  #default = "/"
}

variable "health_check_port" {
  type = number
  #default = 8500
}

variable "health_check_matcher" {
  type = number
  #default = 301
}
