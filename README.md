# EngineNiRad

This is a collection of open-source Terraform scripts for provisioning typical web applications on AWS.

The repository is organized into the following folders:

`components`

These are low-level components that can be reused in your own scripts. Examples: mongodb, rds, elasticache, elasticsearch, vpc, etc.

`frameworks`

These contain template directories for different web frameworks. At the moment only rails is supported, but contributions for other web frameworks are welcome.  You will typically copy the directory for the appropriate framework for your application into the `web` directory under your 

If you're looking for an example on how to get started with these scripts, please see the [Rails starter kit](https://github.com/radamanthus/EngineNiRad-rails-starterkit).