#!/bin/bash
log="install.log"
echo "installing prerequisite software..."
#sudo apt-get -y -qq install subversion
#sudo apt-get -y -qq install mysql-server rabbitmq-server python-dev make swig autoconf
#sudo apt-get -y -qq install memcached openjdk-7-jdk maven nagios-plugins-standard
#sudo apt-get -y -qq install bc libmysqlclient-dev
#sudo apt-get -y -qq install build-essential libreadline-dev libsnmp-dev libssl-dev zip unzip
#sudo apt-get -y -qq install libaio1 python-lxml libpng3 python-libxml2 libxml++2

#try 2
sudo apt-get -y -qq install openjdk-7-jdk maven mysql-server mysql-client libmysqlclient-dev rrdtool librrd-dev python python-dev python-setuptools ccache unzip swig autoconf gcc-4.4 build-essential libsnmp-base libsnmp15 snmp snmpd libsnmp-dev libxml2-dev libxslt1-dev libcairo2-dev libglib2.0-dev libpango1.0-dev erlang libevent-dev memcached rabbitmq-server tk unixodbc subversion libreadline6-dev protobuf-compiler

echo "installing zlib..."
#(trouble with zlib, install manually)
#(http://www.techsww.com/tutorials/libraries/zlib/installation/installing_zlib_on_ubuntu_linux.php)
wget -q http://www.zlib.net/zlib-1.2.7.tar.gz
tar -xzf zlib-1.2.7.tar.gz >> $log
cd zlib-1.2.7
./configure --prefix=/usr/local/zlib >> $log
make >> $log
sudo make install >> $log

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

echo "################################"
echo "# System is ready"
echo "#"
echo "# Now run the following commands"
echo "# $ sudo su - zenoss"
echo "# $ cd zenoss-inst"
echo "# $ ./install.sh"
echo "################################"

#TODO
#The following doesn't work
#echo "running zenoss installer..."
#sudo su -c "cd zenoss-inst;./install.sh" zenoss

