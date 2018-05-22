This is a [Terraform](https://www.terraform.io/) script for automated provisioning of an EC2 instance running MongoDB.

## Quick Start

If this is the first time you're running this script, first run: `terraform init`.

Create a file named `terraform.tfvars` and put in your IAM access key and secret keys there:

```
access_key = "<redacted>"
secret_key = "<redacted>"
```

Don't worry, `terraform.tfvars` is in `.gitignore` so this will not be committed to your repository. For extra measure, I recommend adding the git plugin [git-secrets](https://github.com/awslabs/git-secrets). This will warn you if you're inadvertently committing your credentials into the repository.

Modify `variables.tf`. As of this writing the configurable variables are:
- AWS region
- instance size

Modify `mongod.conf`. This file will be uploaded and copied to `/etc/mongod.conf` and will be used as your MongoDB configuration file.

Finally, you're ready!

To boot your MongoDB instance, run `terraform apply`.

## Customization

### Customizing the MongoDB configuration file

Modify `mongod.conf`. This file will be uploaded to `/etc/mongod.conf` and will be used as the MongoDB configuration file.

### Changing the data volume size

This terraform script setups up a `/data` EBS volume to be used for storing the MongoDB database. The default size is 40GB. You can change the size in `variables.tf`:

```
variable "ebs_data_size" {
  default = "40"
}
```

### Boot on a different AWS region

The script boots the MongoDB instance on us-east-2 (Ohio) by default. To boot the instance in a different AWS region, modify these blocks in `variables.tf`:

```
variable "region" {
  default = "us-east-2"
}

variable "availability_zone" {
  default = "us-east-2a"
}
```

### Change the instance type

TODO - this is waiting on Issue #1: https://github.com/radamanthus/EngineNiRad/issues/1
