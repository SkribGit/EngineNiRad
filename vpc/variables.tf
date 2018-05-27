variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "us-east-2"
}

variable "cidr_block" {
  default = "10.0.0.0/16"
}

variable "tag_name" {
  default = "myvpc"
}
