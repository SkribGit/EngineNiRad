# Setup db volume
mkfs -t ext4 /dev/xvdj
mkdir /db
mount /dev/xvdj /db
chown -R ubuntu:ubuntu /db

# From http://www.codebind.com/linux-tutorials/install-postgresql-9-6-ubuntu-18-04-lts-linux/
sudo sh -c 'echo deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main >> /etc/apt/sources.list.d/pgdg.list'
sudo wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | sudo apt-key add -
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt install -y postgresql-9.6 postgresql-client-9.6 postgresql-contrib-9.6 libpq-dev

# Prepare the database directory
mkdir -p /db/postgresql/9.6
chown -R postgres:postgres /db/postgresql
ln -s /var/lib/postgresql/9.6/main /db/postgresql/9.6
