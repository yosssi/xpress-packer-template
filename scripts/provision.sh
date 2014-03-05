sed -i -e '/Defaults\s\+env_reset/a Defaults\texempt_group=sudo' /etc/sudoers
sed -i -e 's/%sudo  ALL=(ALL:ALL) ALL/%sudo  ALL=NOPASSWD:ALL/g' /etc/sudoers
echo "UseDNS no" >> /etc/ssh/sshd_config

# Make lib directory.
sudo mkdir /home/vagrant/lib
sudo chown vagrant:vagrant /home/vagrant/lib

#Install Docker.
sudo apt-get update
sudo apt-get install -y linux-image-extra-`uname -r`
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
sudo sh -c "echo deb http://get.docker.io/ubuntu docker main > /etc/apt/sources.list.d/docker.list"
sudo apt-get update
sudo apt-get install -y lxc-docker

# Install curl and git.
sudo apt-get install -y curl git

# Install Go 1.2.1.
sudo curl -o /usr/local/go1.2.1.linux-amd64.tar.gz https://go.googlecode.com/files/go1.2.1.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf /usr/local/go1.2.1.linux-amd64.tar.gz
sudo rm /usr/local/go1.2.1.linux-amd64.tar.gz
sudo echo "export GOROOT=/usr/local/go" >> /home/vagrant/.bash_profile
sudo echo "export GOPATH=\$HOME/go" >> /home/vagrant/.bash_profile
sudo echo "PATH=\$PATH:\$GOROOT:\$GOROOT/bin" >> /home/vagrant/.bash_profile

# Install Java.
sudo curl -o /usr/local/lib/jre-7u51-linux-x64.tar.gz https://s3-ap-northeast-1.amazonaws.com/yosssi/java/jre-7u51-linux-x64.gz
sudo tar xvfz /usr/local/lib/jre-7u51-linux-x64.tar.gz -C /usr/local/lib
sudo rm /usr/local/lib/jre-7u51-linux-x64.tar.gz
sudo echo "export JAVA_HOME=/usr/local/lib/jre1.7.0_51" >> /home/vagrant/.bash_profile
sudo echo "PATH=\$PATH:\$JAVA_HOME/bin" >> /home/vagrant/.bash_profile

# Install Elasticsearch.
sudo curl -o /home/vagrant/elasticsearch-1.0.1.tar.gz https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.0.1.tar.gz
sudo tar xvfz /home/vagrant/elasticsearch-1.0.1.tar.gz -C /home/vagrant
sudo rm /home/vagrant/elasticsearch-1.0.1.tar.gz
sudo chown vagrant:vagrant /home/vagrant/elasticsearch-1.0.1
sudo echo "PATH=\$PATH:/home/vagrant/elasticsearch-1.0.1/bin" >> /home/vagrant/.bash_profile

# Install Node.js.
sudo curl -o /usr/local/lib/node-v0.10.26-linux-x64.tar.gz http://nodejs.org/dist/v0.10.26/node-v0.10.26-linux-x64.tar.gz
sudo tar xvfz /usr/local/lib/node-v0.10.26-linux-x64.tar.gz -C /usr/local/lib
sudo rm /usr/local/lib/node-v0.10.26-linux-x64.tar.gz
sudo echo "export NODE_HOME=/usr/local/lib/node-v0.10.26-linux-x64" >> /home/vagrant/.bash_profile
sudo echo "PATH=\$PATH:\$NODE_HOME/bin" >> /home/vagrant/.bash_profile

# Install Bower.
sudo /usr/local/lib/node-v0.10.26-linux-x64/bin/npm install -g bower

# Install Stylus.
sudo /usr/local/lib/node-v0.10.26-linux-x64/bin/npm install -g stylus

# Install UglifyJS2.
sudo /usr/local/lib/node-v0.10.26-linux-x64/bin/npm install -g uglify-js

# Install UglifyCSS.
sudo /usr/local/lib/node-v0.10.26-linux-x64/bin/npm install -g uglifycss

# Install Goat.
sudo curl -o /usr/local/lib/goat https://s3-ap-northeast-1.amazonaws.com/yosssi/goat/linux_amd64/goat
sudo chmod 777 /usr/local/lib/goat
sudo echo "PATH=\$PATH:/usr/local/lib/goat" >> /home/vagrant/.bash_profile

# Change the owner of /home/vagrant/.bash_profile.
sudo chown vagrant:vagrant /home/vagrant/.bash_profile

date > /etc/vagrant_box_build_time

mkdir /home/vagrant/.ssh
wget --no-check-certificate \
    'https://github.com/mitchellh/vagrant/raw/master/keys/vagrant.pub' \
    -O /home/vagrant/.ssh/authorized_keys
chown -R vagrant /home/vagrant/.ssh
chmod -R go-rwsx /home/vagrant/.ssh

sudo apt-get -y install virtualbox-guest-utils

apt-get -y autoremove
apt-get -y clean

echo "cleaning up gest additions"
rm -rf VBoxGuestAdditions_*.iso VBoxGuestAdditions_*.iso.?

echo "cleaning up dhcp leases"
rm /var/lib/dhcp/*

echo "cleaning up udev rules"
mkdir /etc/udev/rules.d/70-persistent-net.rules
rm -rf /dev/.udev/
rm /lib/udev/rules.d/75-persistent-net-generator.rules

dd if=/dev/zero of=/EMPTY bs=1M
rm -f /EMPTY
