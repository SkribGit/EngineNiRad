# Rails

This is a collection of terraform scripts for automated provisioning of a single-instance Rails environment on AWS.

NOTE: This is NOT recommended for production use! This is intended to get you started quickly on a staging environment on AWS. Use on production at your own risk. For production use, see `examples/rails`.

As this is a single-server setup, this does not follow the immutable infrastructure pattern. Deploys are done using capistrano.

## Quick Start

- Generate the deploy key - provide manual instructions for now
- Provision the instance - run `terraform apply`
- Deploy

## Deployment

First, generate a deploy key pair:

- generate the deploy key locally
- upload the private key to the instances
- print the public key and provide the user instructions on how to setup the deploy key on Github and (optional) Bitbucket
- inform the user about securing the private and public key and the ramifications of losing it (user will have to regenerate the key)

run `ssh-keygen -t rsa -N "" -f deploy_key` to generate the deploy key pair

Print the public key:

```
cat deploy_key.pub
```

then copy the key and add it as a deploy key to https://github.com/yourgithubusername/yourgithubappname/settings/keys

Store the deploy key in a secure place. DO NOT add it to a public repository. If you lose the deploy key you will have to delete the old key from Github, generate a new one, and upload the public key to the web instances, into `/home/ubuntu/.ssh/id_rsa.pub`.

capistrano
- add to Gemfile and bundle install
```
group :development do
  gem "capistrano", "~> 3.10", require: false
end
```
https://github.com/capistrano/capistrano#install-the-capistrano-gem

bundle exec cap install

(make sure deploy keys are setup in Github first)

bundle exec cap production deploy

## Customization

To use a different instance size, modify variables.tf

## TODO


---
Do the following steps - manually first, then integrate into the script:

Setup the deploy keys

Do an initial setup of the application


passenger_worker_killer

Use this sample Rails application: http://github.com/radamanthus/helloes
