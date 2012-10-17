#!/bin/bash
echo "installing prerequisite software..."
sudo apt-get -y -qq install subversion
sudo apt-get -y -qq install mysql-server rabbitmq-server python-dev make swig autoconf
sudo apt-get -y -qq install memcached openjdk-7-jdk maven nagios-plugins-standard
sudo apt-get -y -qq install bc libmysqlclient-dev
sudo apt-get -y -qq install build-essential libreadline-dev libsnmp-dev libssl-dev zip unzip
sudo apt-get -y -qq install libaio1 python-lxml libpng3

echo "installing zlib..."
#(trouble with zlib, install manually)
#(http://www.techsww.com/tutorials/libraries/zlib/installation/installing_zlib_on_ubuntu_linux.php)
wget -q http://www.zlib.net/zlib-1.2.7.tar.gz
tar -xzf zlib-1.2.7.tar.gz
cd zlib-1.2.7
./configure --prefix=/usr/local/zlib
make
sudo make install

echo "adding zenoss user..."
sudo useradd -m -U -s /bin/bash zenoss
#(m:create home, U:create user group, s:shell)
sudo mkdir /usr/local/zenoss
sudo chown -R zenoss:zenoss /usr/local/zenoss

echo "configuring rabbitmq..."
sudo rabbitmqctl add_user zenoss zenoss
sudo rabbitmqctl add_vhost /zenoss
sudo rabbitmqctl set_permissions -p /zenoss zenoss '.*' '.*' '.*'

echo "setting up zenoss user environment..."
echo 'export ZENHOME=/usr/local/zenoss' >> .bashrc
echo 'export PYTHONPATH=$ZENHOME/lib/python' >> .bashrc
echo 'export PATH=$ZENHOME/bin:$PATH' >> .bashrc
echo 'export INSTANCE_HOME=$ZENHOME' >> .bashrc

echo "downloading zenoss install files..."
sudo svn --quiet co http://dev.zenoss.org/svn/tags/zenoss-4.2.0/inst /home/zenoss/zenoss-inst
sudo chown -R zenoss:zenoss /home/zenoss/zenoss-inst

echo "running zenoss installer..."
sudo su -c /home/zenoss/zenoss-inst/install.sh zenoss

