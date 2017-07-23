#! /usr/bin/env bash

PASSWORD='c0ldc0mput3r5'
VERSION="5.1.72"
DB_DUMP_FILE="/vagrant/officeap2-db-atos.sql"

echo "Loading $DB_DUMP_FILE"
mysql -uroot -p$PASSWORD < $DB_DUMP_FILE

echo "Running mysql_upgrade to $VERSION"
sudo mysql_upgrade -uroot -p$PASSWORD > $VERSION-logical-upgrade.txt

