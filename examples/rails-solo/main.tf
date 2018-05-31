provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_key_pair" "auth" {
  key_name = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "web" {
  count         = "${var.instance_count}"
  key_name      = "web-${count.index}"
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "${var.instance_size}"

  key_name = "${aws_key_pair.auth.id}"

  availability_zone = "${var.availability_zone}"

  ebs_block_device {
    device_name = "/dev/sdh"
    volume_size = "${var.ebs_data_size}"
  }

  ebs_block_device {
    device_name = "/dev/sdi"
    volume_size = "${var.ebs_mnt_size}"
  }

  ebs_block_device {
    device_name = "/dev/sdj"
    volume_size = "${var.ebs_db_size}"
  }

  connection {
    user = "ubuntu"
  }

  provisioner "file" {
    source = "nginx.conf"
    destination = "/home/ubuntu/nginx.conf"
  }

  provisioner "remote-exec" {
    inline = [
      # Setup mnt volume
      "sudo mkfs -t ext4 /dev/xvdi",
      "sudo mkdir /mnt",
      "sudo mount /dev/xvdi /mnt",
      "sudo chown -R ubuntu:ubuntu /mnt",
      "mkdir -p /mnt/log/nginx",
      "mkdir -p /mnt/log/${var.app_name}",
      # Setup data volume
      "sudo mkfs -t ext4 /dev/xvdh",
      "sudo mkdir /data",
      "sudo mount /dev/xvdh /data",
      "sudo chown -R ubuntu:ubuntu /data",
      # prepare the nginx directories
      "mkdir -p /data/nginx/conf",
      "sudo cp /home/ubuntu/nginx.conf /etc/nginx/nginx.conf",
      # prepare the app directories
      "mkdir -p /data/${var.app_name}/shared/",
      "mkdir -p /data/${var.app_name}/shared/tmp",
      "mkdir -p /data/${var.app_name}/shared/config",
      "mkdir -p /data/${var.app_name}/releases",
      "mkdir -p /data/${var.app_name}/releases_failed",
      "sudo apt-get update",
      # Setup Nginx
      "sudo apt-get install -y nginx",
      # Setup Ruby
      "sudo add-apt-repository -y ppa:brightbox/ruby-ng",
      "sudo apt-get update",
      "sudo apt install -y ruby${var.ruby_version}",
      # Setup Passenger
      # Based on https://www.phusionpassenger.com/library/install/nginx/install/oss/xenial/
      "sudo apt-get install -y dirmngr gnupg",
      "sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7",
      "sudo apt-get install -y apt-transport-https ca-certificates",
      "sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list'",
      "sudo apt-get update",
      "sudo apt-get install -y nginx-extras passenger",
      # Setup PostgreSQL
      "sudo apt-get install -y postgresql postgresql-contrib postgresql-client"
    ]
  }

}
