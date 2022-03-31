
variable "description" {
  type = string
}

variable "name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "tags" {
  type = map(any)
}

# variable "egress" {
#     type = list(object({
#       from_port   = number
#       to_port     = number
#       protocol    = string
#       cidr_blocks  = list(string)
#     }))
# }

# variable "ingress" {
#     type = list(object({
#       from_port   = number
#       to_port     = number
#       protocol    = string
#       cidr_blocks  = list(string)
#     }))
# }
