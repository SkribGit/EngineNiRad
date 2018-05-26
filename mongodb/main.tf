provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_key_pair" "auth" {
  key_name = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "mongodb" {
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

  provisioner "file" {
    source = "mongod.conf"
    destination = "/home/ubuntu/mongod.conf"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo mkfs -t ext4 /dev/xvdh",
      "sudo mkdir /data",
      "sudo mount /dev/xvdh /data",
      "sudo mkdir /data/mongodb",
      "sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2930ADAE8CAF5059EE73BB4B58712A2291FA4AD5",
      "echo \"deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.6 multiverse\" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.6.list",
      "sudo apt-get update",
      "sudo apt-get install -y mongodb-org",
      "echo \"mongodb-org hold\" | sudo dpkg --set-selections",
      "echo \"mongodb-org-server hold\" | sudo dpkg --set-selections",
      "echo \"mongodb-org-shell hold\" | sudo dpkg --set-selections",
      "echo \"mongodb-org-mongos hold\" | sudo dpkg --set-selections",
      "echo \"mongodb-org-tools hold\" | sudo dpkg --set-selections",
      "sudo chown -R mongodb:mongodb /data/mongodb",
      "sudo mv /home/ubuntu/mongod.conf /etc/mongod.conf",
      "sudo service mongod start"
    ]
  }

}
