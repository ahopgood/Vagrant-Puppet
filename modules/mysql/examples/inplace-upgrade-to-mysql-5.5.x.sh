#! /usr/bin/env bash

VERSION="5.5.49"

echo "Stopping current MySQL instance"
sudo /etc/init.d/mysql stop
printf "Removing the following MySQL packages:\n$(rpm -qa | grep -i '^mysql-')"
sudo rpm -e $(rpm -qa | grep -i '^mysql-')

echo "Upgrading to mysql-$VERSION"
sudo rpm -Uvh /vagrant/MySQL-shared-$VERSION-1.rhel5.x86_64.rpm
sudo rpm -Uvh /vagrant/MySQL-server-$VERSION-1.rhel5.x86_64.rpm

echo "Installing MySQL client"
sudo rpm -Uvh /vagrant/MySQL-client-$VERSION-1.rhel5.x86_64.rpm

echo "Starting mysql"
sudo /etc/init.d/mysql start

PASSWORD="c0ldc0mput3r5"

echo "Running mysql_upgrade"
sudo mysql_upgrade -uroot -p$PASSWORD > $VERSION-in-place-upgrade.txt



#echo "Starting MySQL manually as it lost this ability between 5.1.72 and $VERSION"
#sudo /etc/init.d/mysql start

#echo "Resetting root password to the rubbish officeap2 one"
#/usr/bin/mysqladmin -u root password 'c0ldc0mput3r5'
