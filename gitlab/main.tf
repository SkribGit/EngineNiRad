provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_key_pair" "auth" {
  key_name = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "gitlab" {
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "${var.instance_size}"

  key_name = "${aws_key_pair.auth.id}"

  availability_zone = "${var.availability_zone}"

  ebs_block_device {
    device_name = "/dev/sdh"
    volume_size = "${var.ebs_data_size}"
  }

  connection {
    user = "ubuntu"
  }

  # From https://about.gitlab.com/installation/#ubuntu
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y curl openssh-server ca-certificates",
      "sudo echo 'postfix postfix/mailname string ${aws_instance.gitlab.public_ip}' | sudo debconf-set-selections",
      "sudo echo 'postfix postfix/main_mailer_type string \"Internet Site\"' | sudo debconf-set-selections",
      "sudo apt-get install -y postfix",
      "curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash",
      "sudo EXTERNAL_URL=\"http://${aws_instance.gitlab.public_ip}\" apt-get install gitlab-ee"
    ]
  }

}
