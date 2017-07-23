#! /usr/bin/env bash

VERSION="5.0.95"

echo "In install-mysql-$VERSION"
sudo rpm -i /vagrant/MySQL-shared-community-$VERSION-1.rhel5.x86_64.rpm
sudo rpm -i /vagrant/MySQL-server-community-$VERSION-1.rhel5.x86_64.rpm

echo "Installing MySQL client"
sudo rpm -i /vagrant/MySQL-client-community-$VERSION-1.rhel5.x86_64.rpm

PASSWORD="c0ldc0mput3r5"

echo "Resetting root password to the rubbish officeap2 one"
/usr/bin/mysqladmin -u root password $PASSWORD

#Run this in a production environment to remove the anonymous user and the test databases.
#This is instead of the mysqladmin bit above
#/usr/bin/mysql_secure_installation


#Install the original officeap2 db
#$DB_NAME="/vagrant/officeap2-db.sql"
DB_NAME="/vagrant/officeap2-db.sql"

echo "Loading $DB_NAME"
mysql -uroot -p$PASSWORD < $DB_NAME
mysql -uroot -p$PASSWORD -e'flush privileges;'

