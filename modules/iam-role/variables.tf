variable "tags" {
  type = map(any)
}

variable "assume_role_policy" {
}

variable "name" {
  type = string
}

variable "managed_policy_arns" {
  type = list(string)
}
