variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "us-east-2"
}

variable "instance_size" {
  default = "t2.small.elasticsearch"
}

variable "elasticsearch_version" {
  default = "6.2"
}

variable "snapshot_start_hour" {
  default = "23"
}

variable "domain_name" {
  description = "test-es"
}
