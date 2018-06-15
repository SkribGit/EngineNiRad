# TODO
- identify the variables that define a Rails app/environment:
  - app name
  - db name (use the app name)
  - rails_env
  - SCM clone URL
  - hostname
  - instance size
  - data, mnt, db volume sizes
  - passenger worker memory limit
  - number of passenger workers
- ^ put these variables in a configuration file, app.yml
- write a cli app that will parse app.yml and modify these files as needed:
  - configure.sh
  - variables.tf
  - app.conf
  - nginx.conf
https://github.com/radamanthus/rad

- clean up the Quick Start section. Provide links to the other sections as necessary
- complete the Customization section
- complete the setup: nginx should forward requests to the Rails app
https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/ownserver/nginx/oss/bionic/deploy_app.html
- add instructions on how to modify the application for Capistrano
- define the requirements for the cli app (which config files need to be modified)

# Rails

This is a collection of terraform scripts for automated provisioning of a single-instance Rails environment on AWS.

NOTE: This is NOT recommended for production use! This is intended to get you started quickly on a staging environment on AWS. Use on production at your own risk. For production use, see `examples/rails`.

As this is a single-server setup, this does not follow the immutable infrastructure pattern. Deploys are done using capistrano.

## Quick Start

- Generate the deploy key
- Provision the instance
  - `terraform init` (one time only)
  - run `terraform apply`
- Deploy

## Setup the deploy key

Run `ssh-keygen -t rsa -N "" -f deploy_key` to generate the deploy key pair

Print the public key:

```
cat deploy_key.pub
```

then copy the key and add it as a deploy key to https://github.com/yourgithubusername/yourgithubappname/settings/keys

The terraform script will upload the deploy key to the instances. Make sure you generate the deploy key first before provisioning the instance.

Store the deploy key in a secure place. DO NOT add it to a public repository.

In case you lost the deploy key and need to regenerate it, follow these steps:

- delete the old deploy key from your repository (Github, Bitbucket, etc.)
- Generate a new deploy key as above
- Upload the generated public key, `deploy_key.pub`, to `/home/ubuntu/.ssh/id_rsa.pub`

## Provision the instance

If you have not yet done so, please download and setup [Terraform](http://terraform.io).

If this is your first time running the script, run `terraform init`.

To provision and configure the instance, run `terraform apply`.

## Deployment

Add Capistrano to the Gemfile:

```
group :development do
  gem "capistrano", "~> 3.10", require: false
end
```

https://github.com/capistrano/capistrano#install-the-capistrano-gem

Initialize Capistrano:

```
bundle exec cap install
```

Add the instance hostname to `config/deploy/staging.rb`. Run:

```
terraform show | grep public_dns
```

The output will be something like:

```
  public_dns = ec2-18-216-176-104.us-east-2.compute.amazonaws.com
```

Get the hostname and add it to `config/deploy/staging.rb`:

```
server "ec2-18-216-176-104.us-east-2.compute.amazonaws.com", user: "ubuntu", roles: "${app db web}"
```

SSH to the instance and create the file `/data/HelloRails/shared/config/database.yml`

```
staging:
  adapter: postgresql
  encoding: unicode
  database: hellorails
```

Create the secrets file

SSH to the instance and create the file `/data/HelloRails/shared/config/secrets.yml`

Deploy

```
bundle exec cap staging deploy
```

## Customization

The following can be customized in `variables.tf`
- AWS region
- AWS availability zone
- instance size
- volume sizes for the /data, /mnt, and /db volumes

To use a different Ubuntu version, or to use a custom AMI, modify the AMIs map in `variables.tf`. The list of Ubuntu AMIs can be found in https://cloud-images.ubuntu.com/locator/ec2/

For more advanced customizations, you can fork this repository and modify `./configure.sh`.

