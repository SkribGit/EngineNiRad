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

The terraform script will upload the deploy key to the instances. Make sure you generate the deploy key first before running provisioning the instances.

Store the deploy key in a secure place. DO NOT add it to a public repository. If you lose the deploy key you will have to delete the old key from Github, generate a new one, and upload the public key to the web instances, into `/home/ubuntu/.ssh/id_rsa.pub`.

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

To use a different instance size, modify variables.tf

## TODO

---
Do the following steps - manually first, then integrate into the script:

Setup the deploy keys

Do an initial setup of the application


passenger_worker_killer

Use this sample Rails application: http://github.com/radamanthus/helloes
