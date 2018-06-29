provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_key_pair" "auth" {
  key_name = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "postgresql" {
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

  # From http://www.codebind.com/linux-tutorials/install-postgresql-9-6-ubuntu-18-04-lts-linux/
  provisioner "remote-exec" {
    inline = [
      "sudo sh -c 'echo deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main >> /etc/apt/sources.list.d/pgdg.list'",
      "sudo wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -",
      "sudo apt-get -y update",
      "sudo apt-get -y upgrade",
      "sudo apt install -y postgresql-9.6 postgresql-client-9.6 postgresql-contrib-9.6 libpq-dev"
    ]
  }

}
