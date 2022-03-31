variable "size" {
  type = number
}

variable "instance_id" {
  type = string
}

variable "availability_zone" {
  type    = string
  default = "us-east-1a"
}

variable "ebs_count" {
  type    = number
  default = 1
}

variable "encrypted" {
  type = bool
}

variable "type" {
  type    = string
  default = "gp2"
}
