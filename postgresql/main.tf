provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_key_pair" "auth" {
  key_name = "${var.key_name}"
  public_key = "${file(var.public_key_path)}"
}

resource "aws_instance" "choux_db_2018" {
  tags {
    Name = "postgresql"
  }

  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "${var.instance_size}"

  subnet_id = "${var.subnet_id}"
  vpc_security_group_ids = [ "${var.security_groups}" ]
  associate_public_ip_address = true

  key_name = "${aws_key_pair.auth.id}"

  availability_zone = "${var.availability_zone}"

  ebs_block_device {
    device_name = "/dev/sdj"
    volume_size = "${var.ebs_db_size}"
  }

  connection {
    user = "ubuntu"
  }

  # Setup PostgreSQL
  provisioner "remote-exec" {
    inline = [
      # Setup db volume - for t2 instances
      #"sudo mkfs -t ext4 /dev/xvdj",
      #"sudo mkdir /db",
      #"sudo mount /dev/xvdj /db",
      #"sudo chown -R ubuntu:ubuntu /db",

      # Setup db volume - for c5 instances
      "sudo mkfs -t ext4 /dev/nvme0n1",
      "sudo mkdir /db",
      "sudo mount /dev/nvme0n1 /db",
      "sudo chown -R ubuntu:ubuntu /db",

      # From http://www.codebind.com/linux-tutorials/install-postgresql-9-6-ubuntu-18-04-lts-linux/
      "sudo sh -c 'echo deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main >> /etc/apt/sources.list.d/pgdg.list'",
      "sudo wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -",
      "sudo apt-get -y update",


      # The next line is the replacement for "sudo apt-get -y upgrade"
      # that avoids the grub config prompt
      # From https://askubuntu.com/questions/146921/how-do-i-apt-get-y-dist-upgrade-without-a-grub-config-prompt
      "sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::=\"--force-confdef\" -o Dpkg::Options::=\"--force-confold\" dist-upgrade",

      "sudo apt install -y postgresql-9.6 postgresql-client-9.6 postgresql-contrib-9.6 libpq-dev"
    ]
  }

  # Upload the PostgreSQL configuration files
  provisioner "file" {
    source = "postgresql.conf"
    destination = "/home/ubuntu/postgresql.conf"
  }

  provisioner "file" {
    source = "pg_hba.conf"
    destination = "/home/ubuntu/pg_hba.conf"
  }

  provisioner "file" {
    source = "pg_ident.conf"
    destination = "/home/ubuntu/pg_ident.conf"
  }

  # Reconfigure PostgreSQL to use the /db directory
  provisioner "remote-exec" {
    inline = [
      "sudo service postgresql stop",
      "sudo mkdir -p /db/postgresql/9.6",
      "sudo cp -R /var/lib/postgresql/9.6/main /db/postgresql/9.6",
      "sudo chown -R postgres:postgres /db/postgresql",
      "sudo cp /etc/postgresql/9.6/main/postgresql.conf /etc/postgresql/9.6/main/postgresql.conf.bak",
      "sudo cp /home/ubuntu/postgresql.conf /etc/postgresql/9.6/main/postgresql.conf",
      "sudo cp /home/ubuntu/pg_hba.conf /db/postgresql/9.6/main/pg_hba.conf",
      "sudo cp /home/ubuntu/pg_ident.conf /db/postgresql/9.6/main/pg_ident.conf",
      "sudo rm /home/ubuntu/postgresql.conf /home/ubuntu/pg_hba.conf /home/ubuntu/pg_ident.conf",
      "sudo service postgresql start"
    ]
  }
}
