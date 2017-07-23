#!/bin/bash

ls -1 /vagrant/backups/plugins/ | /vagrant/files/restore-directory.sh /var/www/html/wordpress/wp-content/plugins/ /vagrant/backups/plugins/

#ls -1 /home/vagrant/wordpress/backups/ | /vagrant/files/restore-directory.sh /home/vagrant/wordpress/plugins/ /home/vagrant/wordpress/backups/
