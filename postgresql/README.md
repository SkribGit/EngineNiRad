This is a [Terraform](https://www.terraform.io/) script for automated provisioning of an EC2 instance running PostgreSQL.

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
- AWS availability zone
- VPC subnet
- security group
- instance type
- `/db` volume size
- PostgreSQL version

Finally, you're ready!

To boot your PostgreSQL instance, run `terraform apply`.

## Security

This script uses a PostgreSQL configuration file that is very permissive on remote connections. You need to configure the security group to restrict incoming connections on port 5432.

## Customization

### Specify the subnet and the VPC security group

Modify this part of `variables.tf`:

```
variable "subnet_id" {
  default = "subnet-xxxxxxxx"
}

variable "security_groups" {
  default = "sg-xxxxxxxx"
}
```

Note that the subnet should be in the same availability zone as the AZ you've set in this block, also in `variables.tf`:

```
variable "availability_zone" {
  default = "us-east-2b"
}
```

### Change the db volume size

This terraform script setups up a `/db` EBS volume to be used for storing the PostgreSQL database files. The default size is 50GB. You can change the size in `variables.tf`:

```
variable "ebs_db_size" {
  default = "50"
}
```

### Boot on a different AWS region

The script boots the PostgreSQL instance on us-east-2 (Ohio) by default. To boot the instance in a different AWS region, modify these blocks in `variables.tf`:

```
variable "region" {
  default = "us-east-2"
}

variable "availability_zone" {
  default = "us-east-2b"
}
```
