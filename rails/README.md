# Rails

This is a collection of terraform scripts for automated provisioning of a Rails environment on AWS.

## Quick Start

## Customization

TODO
- boot instances inside an autoscaling group
https://github.com/terraform-aws-modules/terraform-aws-autoscaling
https://www.terraform.io/docs/providers/aws/r/autoscaling_group.html

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
