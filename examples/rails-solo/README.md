# TODO
- clean up the Quick Start section. Provide links to the other sections as necessary
- complete the Customization section
- complete the setup: nginx should forward requests to the Rails app
https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/ownserver/nginx/oss/bionic/deploy_app.html

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

Deploy

```
bundle exec cap production deploy
```

## Customization

The following can be customized in `variables.tf`
- AWS region
- AWS availability zone
- instance size
- volume sizes for the /data, /mnt, and /db volumes

To use a different Ubuntu version, or to use a custom AMI, modify the AMIs map in `variables.tf`. The list of Ubuntu AMIs can be found in https://cloud-images.ubuntu.com/locator/ec2/

For more advanced customizations, you can fork this repository and modify `./configure.sh`.

