# Rails

This is a collection of terraform scripts for automated provisioning of a single-instance Rails environment on AWS.

NOTE: This is NOT recommended for production use! This is intended to get you started quickly on a staging environment on AWS. Use on production at your own risk. For production use, see `examples/rails`.

As this is a single-server setup, this does not follow the immutable infrastructure pattern. Deploys are done using mina.

## Quick Start

## Customization

To use a different instance size, modify variables.tf

## TODO

Do the following steps - manually first, then integrate into the script:
Initialize the PostgreSQL database

Setup the deploy keys

Do an initial setup of the application

Do a mina deploy

passenger_worker_killer

Use this sample Rails application: http://github.com/radamanthus/helloes
