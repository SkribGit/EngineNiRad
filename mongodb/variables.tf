variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "us-east-2"
}
variable "availability_zone" {
  default = "us-east-2a"
}
variable "ebs_data_size" {
  default = "40"
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
