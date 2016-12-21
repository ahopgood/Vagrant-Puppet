#!/bin/bash

ls -1 /var/www/html/wordpress/wp-content/plugins/ | /vagrant/files/backup-directory.sh /vagrant/backups/ /var/www/html/wordpress/wp-content/plugins/
