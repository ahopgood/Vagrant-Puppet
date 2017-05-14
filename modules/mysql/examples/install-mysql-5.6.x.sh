#! /usr/bin/env bash

VERSION="5.6.19"

echo "In install-mysql-$VERSION"
sudo rpm -i /vagrant/MySQL-shared-$VERSION-1.rhel5.x86_64.rpm
sudo rpm -i /vagrant/MySQL-server-$VERSION-1.rhel5.x86_64.rpm

echo "Installing MySQL client"
sudo rpm -i /vagrant/MySQL-client-$VERSION-1.rhel5.x86_64.rpm

echo "Starting MySQL manually as it lost this ability between 5.1.72 and $VERSION"
sudo /etc/init.d/mysql start

echo "Attempting to retrieve temp password as this was introduced between 5.5.49 and $VERSION"
TEMP_PASSWORD=$(sudo cat $HOME/.mysql_secret | awk '{ print $18 }')
echo "Temp password is $TEMP_PASSWORD"

echo "Resetting root password to the rubbish officeap2 one"
mysql -uroot -p$TEMP_PASSWORD --connect-expired-password -e"SET PASSWORD FOR 'root'@'localhost' = PASSWORD('c0ldc0mput3r5');"


