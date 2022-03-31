variable "ami" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "user_data" {
  type    = string
  default = ""
}

variable "tags" {
  type = map(any)
}

variable "subnet_id" {
  type = string
}

variable "ec2_count" {
  type    = number
  default = 1
}
variable "key_name" {
  type = string
}

variable "availability_zone" {
  type    = string
  default = "us-east-1a"
}

variable "iam_instance_profile" {
  type    = string
  default = ""
}
