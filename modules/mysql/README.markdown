# mysql

This is the mysql module. It provides...

MySQL shared libraries, MySQL server and a MySQL client.

It will also uninstall the old shared libraries from centos systems.

## CentOS
Currently supports MySQL versions:

* 5.7.13

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
Ubuntu is currently not supported

## Java Connector
Currently only version 5.1.40 is supported on:
* CentOS 6

## To Do
* **done** - Fix CentOS 6 with a call to /etc/init.d/mysqld start & sleep 10 followed by another call to /etc/init.d/mysqld start
* **done** - Create test profiles for CentOS 6, CentOS 7 and Ubuntu
* **done** - Separate files folder into /OS/Ver folder structure
* **done** Update installers to use this new structure
* **done** Update create_database definition to use the db name when calling the exec block so it can be called multiple times 
* **done** Update create_user definition to use the db name when calling the exec block so it can be called multiple times
* **done** Delete my.cnf file after resetting the default password? Or is it needed for us to reset it in future? Yes it is
* Add tests for the differential_backup and differential_restore definitions
* Add support for the java connector (j/connector)
 * CentOS 6
 * CentOS 7
 * Ubuntu
 * Add tests for java connector
* Add test for create_database
* Add test for create_user
* Add support for 5.5.x
* Add package dependency diagrams for each version of MySQL and OS
 * 5.7.13
  * CentOS 6
  * CentOS 7
  * Ubuntu 15
 * 5.6.36
  * CentOS 6
  * CentOS 7
  * Ubuntu 15
  * Add tests for create_database, create_user definitions
* Add support for 5.6.x
 * Create mysql user and group (definitely needed for 5.6.35)
 * Create exec for reading the password from /root/.mysql_secret 
 * Create and run tests for create_database
 * Create and run tests for create_users
* Add support for Ubuntu