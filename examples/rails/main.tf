provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_elb" "web" {
  name                = "${var.environment_name}"
  availability_zones  = ["${data.aws_availability_zones.all.names}"]

  listener {
    elb_port          = "${var.elb.external_port}"
    elb_protocol      = "${var.elb.external_protocol}"
    instance_port     = "${var.elb.instance_port}"
    instance_protocol = "${var.elb.instance_protocol}"
  }
}
