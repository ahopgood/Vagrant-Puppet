#!/bin/bash

ls -1 /home/vagrant/wordpress/backups/ | /vagrant/files/restore-directory.sh /home/vagrant/wordpress/backups/ /home/vagrant/wordpress/plugins/