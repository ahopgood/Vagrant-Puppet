!# /usr/bin/bash
sudo iptables-save > /vagrant/files/backup/iptables-save.bak

sudo systemctl stop firewalld
sudo systemctl disable firewalld

sudo rpm -Uvh /vagrant/files/iptables-1.4.21-16.el7.x86_64.rpm

sudo iptables-restore < /vagrant/files/backup/iptables-save.bak

sudo iptables -I INPUT 1 -p tcp -m state --state NEW --dport 8080 -j ACCEPT

sudo rpm -Uvh /vagrant/files/iptables-services-1.4.21-16.el7.x86_64.rpm

sudo systemctl enable iptables
sudo systemctl start iptables
sudo service iptables save

