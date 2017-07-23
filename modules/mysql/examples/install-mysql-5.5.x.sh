#! /usr/bin/env bash

VERSION="5.5.49"

echo "In install-mysql-$VERSION"
sudo rpm -i /vagrant/MySQL-shared-$VERSION-1.rhel5.x86_64.rpm
sudo rpm -i /vagrant/MySQL-server-$VERSION-1.rhel5.x86_64.rpm

echo "Installing MySQL client"
sudo rpm -i /vagrant/MySQL-client-$VERSION-1.rhel5.x86_64.rpm

echo "Starting MySQL manually as it lost this ability between 5.1.72 and $VERSION"
sudo /etc/init.d/mysql start

echo "Resetting root password to the rubbish officeap2 one"
/usr/bin/mysqladmin -u root password 'c0ldc0mput3r5'
