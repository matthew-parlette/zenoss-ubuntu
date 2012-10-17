#!/bin/bash
sudo apt-get -y install subversion
sudo apt-get -y install mysql-server rabbitmq-server python-dev make swig autoconf
sudo apt-get -y install memcached openjdk-7-jdk maven nagios-plugins-standard
sudo apt-get -y install bc libmysqlclient-dev
sudo apt-get -y install build-essential libreadline-dev libsnmp-dev libssl-dev zip unzip
sudo apt-get -y install libaio1 libpython-lxml libpng3

#(trouble with zlib, install manually)
#(http://www.techsww.com/tutorials/libraries/zlib/installation/installing_zlib_on_ubuntu_linux.php)
wget http://www.zlib.net/zlib-1.2.7.tar.gz
tar -xvzf zlib-1.2.7.tar.gz
cd zlib-1.2.7
./configure --prefix=/usr/local/zlib
make
sudo make install

sudo useradd -m -U -s /bin/bash zenoss
#(m:create home, U:create user group, s:shell)
sudo mkdir /usr/local/zenoss
sudo chown -R zenoss:zenoss /usr/local/zenoss

sudo rabbitmqctl add_user zenoss zenoss
sudo rabbitmqctl add_vhost /zenoss
sudo rabbitmqctl set_permissions -p /zenoss zenoss '.*' '.*' '.*'

sudo su - zenoss
#nano .bashrc
echo 'export ZENHOME=/usr/local/zenoss' >> .bashrc
echo 'export PYTHONPATH=$ZENHOME/lib/python' >> .bashrc
echo 'export PATH=$ZENHOME/bin:$PATH' >> .bashrc
echo 'export INSTANCE_HOME=$ZENHOME' >> .bashrc

svn co http://dev.zenoss.org/svn/tags/zenoss-4.2.0/inst zenoss-inst
cd zenoss-inst

