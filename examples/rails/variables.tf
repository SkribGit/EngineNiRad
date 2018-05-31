variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "us-east-2"
}
variable "availability_zone" {
  default = "us-east-2a"
}

variable "app_name" {
  default = "myapp"
}

variable "environment_name" {
  default = "staging"
}

variable "elb" {
  type = "map"
  default = {
    "external_port"       = "80",
    "external_protocol"   = "http",
    "instance_port"       = "81",
    "instance_protocol"   = "http"
  }
}

variable "instance_size" {
  default = "t2.small"
}

variable "instance_count" {
  default = "1"
}

variable "ebs_data_size" {
  default = "30"
}

variable "ebs_mnt_size" {
  default = "25"
}

variable "ruby_version" {
  default = "2.5"
}

variable "availability_zones" {
  type = "map"
  default = {
    "us-east-1" = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"],
    "us-east-2" = ["us-east-2a", "us-east-2b", "us-east-2c"],
    "us-west-1" = ["us-west-1a", "us-west-1b", "us-west-1c"],
    "us-west-2" = ["us-west-2a", "us-west-2b", "us-west-2c"],
    "ca-central-1" = ["ca-central-1a", "ca-central-1b"],
    "eu-west-1" = ["eu-west-1a", "eu-west-1b", "eu-west-1c"],
    "eu-west-2" = ["eu-west-2a", "eu-west-2b", "eu-west-2c"],
    "eu-west-3" = ["eu-west-3a", "eu-west-3b", "eu-west-3c"],
    "eu-central-1" = ["eu-central-1a", "eu-central-1b", "eu-central-1c"],
    "ap-northeast-1" = ["ap-northeast-1a", "ap-northeast-1b", "ap-northeast-1c"],
    "ap-northeast-2" = ["ap-northeast-2a", "ap-northeast-2b"],
    "ap-southeast-1" = ["ap-southeast-1a", "ap-southeast-1b"],
    "ap-southeast-2" = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
  }
}

# Ubuntu 16.04 AMI IDs on various regions
variable "amis" {
  type = "map"
  default = {
    "us-east-1" = "ami-43a15f3e",
    "us-east-2" = "ami-916f59f4",
    "us-west-2" = "ami-4e79ed36",
    "ap-southeast-1" = "ami-52d4802e"
  }
}

variable "public_key_path" {
  description = <<DESCRIPTION
Path to the SSH public key to be used for authentication.
Ensure this keypair is added to your local SSH agent so provisioners can
connect.
Example: ~/.ssh/terraform.pub
DESCRIPTION
}

variable "key_name" {
  description = "Desired name of AWS key pair"
}
