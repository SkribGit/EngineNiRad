# Rails

This is a collection of terraform scripts for automated provisioning of a Rails environment on AWS.

## Quick Start

## Customization

TODO

Configurable variables:
- availability zones to use (default: distribute evenly)

Modules:
- passenger
- unicorn
- puma

Conditional code to determine if a module will be loaded:
https://github.com/hashicorp/terraform/issues/12906

- monit or upstart?

Plan:
- Implement Passenger first
- Then puma-upstart
- Then unicorn-monit
