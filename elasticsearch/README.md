This is a [Terraform](https://www.terraform.io/) script for automated provisioning of an EC2 Elasticsearch domain

## Quick Start

If this is the first time you're running this script, first run: `terraform init`.

Create a file named `terraform.tfvars` and put in your IAM access key and secret keys there:

```
access_key = "<redacted>"
secret_key = "<redacted>"
```

Don't worry, `terraform.tfvars` is in `.gitignore` so this will not be committed to your repository. For extra measure, I recommend adding the git plugin [git-secrets](https://github.com/awslabs/git-secrets). This will warn you if you're inadvertently committing your credentials into the repository.

Modify `variables.tf`. As of this writing the configurable variables are:
- domain name
- AWS region
- instance size
- ebs volume size
- Elasticsearch version

Finally, you're ready!

To boot your Elasticsearch domain, run `terraform apply`.

## Customization

### Boot on a different AWS region

The script boots on us-east-2 (Ohio) by default. To boot the Elasticsearch domain in a different AWS region, modify this block in `variables.tf`:

```
variable "region" {
  default = "us-east-2"
}
```

### Change the instance type

The script boots a t2.small instance by default. To change the instance size, modify this block in `variables.tf`:


```
variable "instance_size" {
  default = "t2.small.elasticsearch"
}
```

For more information on AWS Elasticsearch service sizing, see https://docs.aws.amazon.com/elasticsearch-service/latest/developerguide/sizing-domains.html.

### Change the Elasticsearch version

The script boots Elasticsearch 6.2 by default. To use a different Elasticsearch version, modify this block in `variables.tf`:

```
variable "elasticsearch_version" {
  default = "6.2"
}
```
