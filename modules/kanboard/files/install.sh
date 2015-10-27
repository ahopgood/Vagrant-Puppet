#!/bin/bash

# /etc/php.ini
# match short_open_tag = Off then rewrite to
# short_open_tag = On

# sudo /etc/init.d/httpd restart

# systemctl restart httpd.service

cd /var/www/html
unzip /vagrant/files/kanboard-1-0-19.zip
chown -R apache:apache kanboard/data

# Use the iptable module here
sudo /etc/init.d/iptables stop

#sudo mysql -uroot -proot < "create database kanboard"
#echo "create database kanboard" | mysql -uroot -proot;

#mysql -uroot -proot kanboard < /vagrant/files/2015-10-25-kanboardbackup.sql

#Create a config.php.erb file.
#cp kanboard/default.config.php kanboard/config.php


