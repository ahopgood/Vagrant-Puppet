!# /usr/bin/bash

sudo iptables-restore < /vagrant/files/backup/iptables-save.bak

sudo service iptables save

sudo systemctl disable iptables
sudo systemctl stop iptables

sudo rpm -evh /vagrant/files/iptables-services-1.4.21-16.el7.x86_64.rpm

sudo systemctl enable firewalld

sudo systemctl start firewalld
