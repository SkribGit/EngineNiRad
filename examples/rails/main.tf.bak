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
      "sudo apt install -y ruby${var.ruby_version}"
    ]
  }

}
