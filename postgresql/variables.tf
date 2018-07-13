variable "access_key" {}
variable "secret_key" {}
variable "region" {
  default = "us-east-2"
}
variable "availability_zone" {
  default = "us-east-2b"
}
variable "instance_size" {
  default = "t2.small"
}
variable "ebs_db_size" {
  default = "40"
}

variable "postgresql_version" {
  default = "9.6"
}

# NOTE: The subnet has to be in the same region as the region specified in aws.region above
variable "subnet_id" {
  default = "subnet-xxxxxxxx"
}

variable "security_groups" {
  default = "sg-xxxxxxxx"
}

# Ubuntu 18.04 AMI IDs on various regions
# These are the AMIs for hvm:ebs-ssd instances
# From https://cloud-images.ubuntu.com/locator/ec2/
variable "amis" {
  type = "map"
  default = {
    "ap-northeast-1" = "ami-9ed12ce1",
    "ap-northeast-2" = "ami-943e96fa",
    "ap-southeast-1" = "ami-8cc7f5f0",
    "ap-southeast-2" = "ami-5d3aea3f",
    "us-east-1" = "ami-432eb53c",
    "us-east-2" = "ami-18073b7d",
    "us-west-1" = "ami-29918949",
    "us-west-2" = "ami-d27709aa"
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
