# Setup mnt volume
mkfs -t ext4 /dev/xvdi
mkdir /mnt
mount /dev/xvdi /mnt
chown -R ubuntu:ubuntu /mnt
mkdir -p /mnt/log/nginx
mkdir -p /mnt/log/helloes

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
mkdir -p /data/helloes/shared/
mkdir -p /data/helloes/shared/tmp
mkdir -p /data/helloes/shared/config
mkdir -p /data/helloes/releases
mkdir -p /data/helloes/releases_failed
chown -R ubuntu:ubuntu /data/helloes

apt-get update

# Setup Nginx
apt-get install -y nginx

# Setup Ruby
add-apt-repository -y ppa:brightbox/ruby-ng
apt-get update
apt install -y ruby2.5

# Setup Passenger
# Based on https://www.phusionpassenger.com/library/install/nginx/install/oss/xenial/
apt-get install -y dirmngr gnupg
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
apt-get install -y apt-transport-https ca-certificates
sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list'
apt-get update
apt-get install -y nginx-extras passenger

# Setup PostgreSQL
apt-get install -y postgresql postgresql-contrib postgresql-client

# initialize the DB
cd /tmp
mkdir -p /db/postgresql/9.5
chown -R postgres:postgres /db/postgresql
pg_createcluster 9.5 helloes -d /db/postgresql/9.5
sudo -u postgres bash -c 'createdb helloes'
sudo -u postgres bash -c 'createuser ubuntu'
sudo -u postgres bash -c 'psql -c "GRANT ALL PRIVILEGES ON DATABASE helloes TO ubuntu"'
# TODO
# setup the deploy keys
# do an initial deploy of the app
# verify that mina deploy works
# setup passenger_worker_killer
