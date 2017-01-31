# mysql

This is the mysql module. It provides...

MySQL shared libraries, MySQL server and a MySQL client.

It will also uninstall the old shared libraries from centos systems.

## CentOS
Currently supports MySQL 5.7.13 only.
Makes use of the *.my.cnf* file to set the root password and allows us to reset it later, protected by being present in the home directory of the user running the command.
### CentOS 6
This module also:

* **Removes** the mysql-libs dependency

### CentOS 7
This module also:  

* **Installs** libaio 0.3.109 dependency
* **Removes** the postfix dependency
* **Removes** the mariadb dependency

Makes use of **systemctl** to start the mysql daemon (mysqld).

## Ubuntu
Ubunut is currently not supported

## To Do
* Fix CentOS 6 with a call to /etc/init.d/mysqld start & sleep 10 followed by another call to /etc/init.d/mysqld start
* **done** - Create test profiles for CentOS 6, CentOS 7 and Ubuntu
* Separate files folder into /OS/Ver folder structure
* Update installers to use this new structure
* Add support for Ubuntu
* Update create_database definition to use the db name when calling the exec block so it can be called multiple times 
* Update create_user definition to use the db name when calling the exec block so it can be called multiple times
* Add support for 5.5.x
* Add support for 5.6.x
* Add tests for create_database, create_user definitions
* Add tests for the differential_backup and differential_restore definitions
* Delete my.cnf file after resetting the default password? Or is it needed for us to reset it in future?