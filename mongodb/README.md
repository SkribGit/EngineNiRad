This is a [Terraform](https://www.terraform.io/) script for automated provisioning of an EC2 instance running MongoDB.

## Usage

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
