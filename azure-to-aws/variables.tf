variable "name" {
  type    = string
  default = "example"
}

variable "location" {
  type    = string
  default = "example"
}

variable "aws_gateway_address" {
  type        = string
  description = "Address of the AWS gateway"
}

variable "aws_gateway_address_space" {
  type        = list(string)
  description = "Address space of the AWS gateway"
}

variable "aws_gateway_shared_key" {
  type        = string
  description = "Shared key"
}

