!# /usr/bin/bash

sudo rpm -Uvh libaio-0.3.109-13.el7.x86_64.rpm

sudo rpm -Uvh mysql-community-libs-5.7.13-1.el7.x86_64.rpm
sudo rpm -Uvh mysql-community-client-5.7.13-1.el7.x86_64.rpm

sudo yum remove mariadb-libs
sudo rpm -Uvh mysql-community-common-5.7.13-1.el7.x86_64.rpm

sudo rpm -Uvh mysql-community-server-5.7.13-1.el7.x86_64.rpm

sudo service mysql start