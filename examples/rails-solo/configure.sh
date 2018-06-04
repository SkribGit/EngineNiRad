## Configurable variables here
# app_name = hellorails
# db_name = hellorails

# Setup mnt volume
mkfs -t ext4 /dev/xvdi
mkdir /mnt
mount /dev/xvdi /mnt
chown -R ubuntu:ubuntu /mnt
mkdir -p /mnt/log/nginx
mkdir -p /mnt/log/hellorails

# Setup data volume
mkfs -t ext4 /dev/xvdh
mkdir /data
mount /dev/xvdh /data
chown -R ubuntu:ubuntu /data

# Setup db volume
mkfs -t ext4 /dev/xvdj
mkdir /db
mount /dev/xvdj /db
chown -R ubuntu:ubuntu /db

# prepare the nginx directories
mkdir -p /data/nginx/conf
cp /home/ubuntu/nginx.conf /etc/nginx/nginx.conf

# prepare the app directories
mkdir -p /data/hellorails/shared/
mkdir -p /data/hellorails/shared/tmp
mkdir -p /data/hellorails/shared/config
mkdir -p /data/hellorails/releases
mkdir -p /data/hellorails/releases_failed
chown -R ubuntu:ubuntu /data/hellorails

apt-get update

# Setup Nginx
apt-get install -y nginx

# Setup Ruby
apt-get install -y build-essential patch ruby-dev zlib1g-dev liblzma-dev
gem install bundler

# Setup a Javascript runtime
apt-get install -y nodejs

# Setup Passenger
# Based on https://www.phusionpassenger.com/library/install/nginx/install/oss/bionic/
apt-get install -y dirmngr gnupg
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
apt-get install -y apt-transport-https ca-certificates
sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger bionic main > /etc/apt/sources.list.d/passenger.list'
apt-get update
apt-get install -y libnginx-mod-http-passenger

# Setup PostgreSQL
apt-get install -y postgresql postgresql-contrib postgresql-client libpq-dev

# initialize the DB
cd /tmp
mkdir -p /db/postgresql/10.3
chown -R postgres:postgres /db/postgresql
ln -s /var/lib/postgresql/10/main /db/postgresql/10.3
sudo -u postgres bash -c 'createdb hellorails'
sudo -u postgres bash -c 'createuser ubuntu'
sudo -u postgres bash -c 'psql -c "GRANT ALL PRIVILEGES ON DATABASE hellorails TO ubuntu"'

# Ensure the deploy key has the correct file permissions
mkdir -p /home/ubuntu/.ssh
chown -R ubuntu:ubuntu /home/ubuntu/.ssh
mv /home/ubuntu/deploy_key.pub /home/ubuntu/.ssh/id_rsa.pub
chmod 400 /home/ubuntu/.ssh/id_rsa.pub

# TODO
# do an initial deploy of the app
# verify that cap deploy works
# setup passenger_worker_killer
