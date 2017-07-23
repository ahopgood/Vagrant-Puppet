#! /usr/bin/env bash

VERSION="5.7.10"

echo "In install-mysql-$VERSION"
#Installation has been modified from single line calls to rpm as there were dependencies that looped, installing all at once seems to be the only way to surmount this
# Dependencies are:
# mysql-community-server
# mysql-community-client
# mysql-community-libs
# mysql-community-lib-compat
# mysql-community-common
# mysql
sudo rpm -Uvh /vagrant/mysql-community-{server,client,common,libs,libs-compat}-$VERSION-* /vagrant/mysql-$VERSION-*
#sudo yum install -y /vagrant/mysql-community-{server,client,common,libs,libs-compat}-$VERSION-* /vagrant/mysql-$VERSION-*

echo "Starting MySQL manually as it lost this ability between 5.1.72 and $VERSION"
sudo /etc/init.d/mysqld start

#Try to disable password validation
echo "Removing the validate_password plugin to ensure old insecure officeap password can be used, restarting mysqld to make changes take effect"
echo "validate_password=OFF" | sudo tee -a /etc/my.cnf 

sudo /etc/init.d/mysqld restart

echo "Attempting to retrieve temp password as this was introduced between 5.5.49 and $VERSION"
TEMP_PASSWORD=$(sudo grep 'temporary password' /var/log/mysqld.log | awk '{ print $11 }')
echo "Temp password is $TEMP_PASSWORD"

TEMP_PASSWORD=$(echo $TEMP_PASSWORD | tr ! \!)
echo "Temp password after escaping the bang is $TEMP_PASSWORD"

echo "Resetting root password to the rubbish officeap2 one"
mysql -uroot -p"$TEMP_PASSWORD" --connect-expired-password -e"SET PASSWORD FOR 'root'@'localhost' = PASSWORD('c0ldc0mput3r5');"

