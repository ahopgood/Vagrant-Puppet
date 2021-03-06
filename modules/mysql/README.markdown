# mysql

This is the mysql module. It provides...

MySQL shared libraries, MySQL server and a MySQL client.

It will also uninstall the old shared libraries from centos systems.

## CentOS
Currently supports MySQL versions:

* 5.7.13
* 5.6.35

Makes use of the *.my.cnf* file to set the root password and allows us to reset it later, protected by being present in the home directory of the user running the command.
### CentOS 6
This module also:

* **Removes** the mysql-libs dependency
#### MySQL 5.6.35 package names
Puppet reports the package names as follows:
```
package { 'MySQL-client':
  ensure => '5.6.35-1.el6',
}
package { 'MySQL-server':
  ensure => '5.6.35-1.el6',
}
package { 'MySQL-shared':
  ensure => '5.6.35-1.el6',
}
package { 'MySQL-shared-compat':
  ensure => '5.6.35-1.el6',
}
```

### CentOS 7
This module also:  

* **Installs** libaio 0.3.109 dependency
* **Removes** the postfix dependency
* **Removes** the mariadb dependency
* **Installs** perl-Data-Dumper for MySQL 5.6.35  

Makes use of **systemctl** to start the mysql daemon (mysqld).

## Ubuntu
Currently supports MySQL versions:

* 5.7.13
* 5.6.35

Makes use of the *.my.cnf* file to set the root password and allows us to reset it later, protected by being present in the home directory of the user running the command.
### Ubuntu 15.10 (Wily)
This module needs to make a horrible hack with an `exec` puppet call on the server .deb package in order to allow for non-interactive install via the `DEBIAN_FRONTEND=noninteractive` environment variable.  
This means you cannot universally reference the `Package["mysql-community-server"]` across both CentOS and Ubuntu.

## Java Connector
Currently only version 5.1.40 is supported on:

* CentOS 6
* CentOS 7
* Ubuntu 15.10

## To Do
* **done** - Fix CentOS 6 with a call to /etc/init.d/mysqld start & sleep 10 followed by another call to /etc/init.d/mysqld start
* **done** - Create test profiles for CentOS 6, CentOS 7 and Ubuntu
* **done** - Separate files folder into /OS/Ver folder structure
* **done** Update installers to use this new structure
* **done** Update create_database definition to use the db name when calling the exec block so it can be called multiple times 
* **done** Update create_user definition to use the db name when calling the exec block so it can be called multiple times
* **done** Delete my.cnf file after resetting the default password? Or is it needed for us to reset it in future? Yes it is
* **done** Add support for the java connector (j/connector)
 * **done** CentOS 6
 * **done** CentOS 7
 * **done** Ubuntu
* **done** Add tests for java connector
* **done** Add test for create_database
* **done** Add test for create_user
* **done**  Add support for 5.6.x
 * **done** Create mysql user and group (definitely needed for 5.6.35)
 * **done** Create exec for reading the password from /root/.mysql_secret 
 * **done** Create and run tests for create_database
 * **done** Create and run tests for create_users
* Add tests for the differential_backup and differential_restore definitions
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
