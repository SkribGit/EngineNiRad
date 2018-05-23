provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_elasticsearch_domain" "es" {
  domain_name = "${var.domain_name}"
  elasticsearch_version = "${var.elasticsearch_version}"

  cluster_config {
    instance_type = "${var.instance_size}"
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  advanced_options {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  snapshot_options {
    automated_snapshot_start_hour = "${var.snapshot_start_hour}"
  }

  tags {
    Domain = "${var.domain_name}"
  }
}
