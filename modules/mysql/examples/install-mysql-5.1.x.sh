#! /usr/bin/env bash

VERSION="5.1.72"

echo "In install-mysql-$VERSION"
sudo rpm -Uvh /vagrant/MySQL-shared-community-$VERSION-1.rhel5.x86_64.rpm
sudo rpm -Uvh /vagrant/MySQL-server-community-$VERSION-1.rhel5.x86_64.rpm

echo "Installing MySQL client"
sudo rpm -Uvh /vagrant/MySQL-client-community-$VERSION-1.rhel5.x86_64.rpm

#echo "Resetting root password to the rubbish officeap2 one"
/usr/bin/mysqladmin -u root password 'c0ldc0mput3r5'
