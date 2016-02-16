# Class: mysql
#
# This module manages mysql
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
#include fileserver
class mysql {  
  #Modify this into a class that we can pass args into, e.g. mysql version number, os speciic installer classes etc.
  #NOTE: This script will reset the root password if it cannot login to the mysql service
  $local_install_path   = "/etc/puppet/"
  $local_install_dir    = "${local_install_path}installers"
  $puppet_file_dir      = "modules/mysql/"

  $MySQL_shared_compat  = "MySQL-shared-compat-5.6.19-1.el6.x86_64.rpm"
  $MySQL_server         = "MySQL-server-5.6.19-1.el6.x86_64.rpm"
  $MySQL_client         = "MySQL-client-5.6.19-1.el6.x86_64.rpm"
  $MySQL_shared         = "MySQL-shared-5.6.19-1.el6.x86_64.rpm"

  $password             = "root"

  #Load the installers from the puppet fileserver into the local filesystem
  #Try giving the file a name and separate target location so we don't need to fully qualify the path
  
  #Ensure that the local install directory exists
  #Ensure the destination directory for the installers is present
  file {
    "$local_install_dir":
    ensure      =>  directory,
    mode        =>  0666,
#    owner       =>  'installer',
  }
  
  file {
      "${MySQL_shared_compat}":
      path    =>  "${local_install_dir}/${MySQL_shared_compat}",
      ensure  =>  present,
      source  =>  ["puppet:///${puppet_file_dir}${MySQL_shared_compat}"],
  }
  
  package {
      'MySQL-shared-compat':
      ensure      =>  installed,
      provider    =>  'rpm',
      source      =>  "${local_install_dir}/${MySQL_shared_compat}",
      require     =>  File["${MySQL_shared_compat}"],
  }
  
  package {
    'mysql-libs':
    ensure      =>  absent,
    provider    =>  'rpm',
    require     =>  Package['MySQL-shared-compat'],
    before      =>  [Package['MySQL-shared'], Package['MySQL-server'], Package['MySQL-client']],
  }
  
  file {
    "${MySQL_shared}":
    path        => "${$local_install_dir}/${MySQL_shared}",
    ensure      =>  present,
    source      =>  ["puppet:///${puppet_file_dir}${MySQL_shared}"],
  }
  
  package {
    'MySQL-shared':
    ensure      =>  installed,
    provider    =>  'rpm',
    source      =>  "${local_install_dir}/${MySQL_shared}",
    require     =>  File["${MySQL_shared}"],
  }
  
  file {
    "${MySQL_server}":
    path    =>  "${local_install_dir}/${MySQL_server}",
    ensure  =>  present,
    source  =>  ["puppet:///${puppet_file_dir}${MySQL_server}"],  
  }
  
  package {
    'MySQL-server':
    ensure      =>  installed,
    provider    =>  'rpm',
    source      =>  "${local_install_dir}/${MySQL_server}",
    require     =>  File["${MySQL_server}"],
  }
  
  file{
    "${MySQL_client}":
    path      => "${local_install_dir}/${MySQL_client}",
    ensure    => present,
    source    => ["puppet:///${puppet_file_dir}${MySQL_client}"],
  }
  
  package {
    'MySQL-client':
    ensure      =>  installed,
    provider    =>  'rpm',
    source      =>  "${local_install_dir}/${MySQL_client}",
    require     =>  File["${MySQL_client}"],
  }
   
  #Need to check the service is running first
  exec {
    "Stop mysql":
    #refreshonly =>  true,
    #subscribe   =>  [Package['MySQL-client'], Package['MySQL-server'], Package['MySQL-shared']],
    unless      =>  "/usr/bin/mysqladmin -uroot -p${password} status",
    path        =>  "/usr/bin/mysql",
    command     =>  "/etc/init.d/mysql stop",
  #  before      =>  Exec['Skip grant tables'],  
  }
  
  #Start the service in safe mode
  exec {
    "Skip grant tables":
    path        =>  "/usr/bin/",
    unless      =>  "/usr/bin/mysqladmin status",
    command     =>  "sudo mysqld_safe --skip-grant-tables &", 
    #before      =>  Exec['Set MySQL root password'],
    refreshonly =>  true,
    subscribe   =>  Exec['Stop mysql'],
    require     =>  Exec['Stop mysql'],
  }
  
  #Set the root password
  exec {
    "Set MySQL root password":
    path        =>  "/usr/bin/",
    command     =>  "sudo sleep 5 && mysql mysql -e \"update user set password=PASSWORD('$password') where user='root'; flush privileges;\"",
    refreshonly =>  true,
    subscribe   =>  Exec['Skip grant tables'],
    require     =>  Exec['Skip grant tables'],  
  }
  
  #stop the service again to drop out of safe mode
  exec {
    "Stop mysqld_safe":
    path        =>  "/usr/sbin/mysqld",
    command     =>  "/etc/init.d/mysql stop",
    refreshonly =>  true,
    subscribe   =>  Exec['Set MySQL root password'],
    require     =>  Exec['Set MySQL root password'],
  }
  
  #Start service again normally without skipping the grant tables.
  exec {
    "Start mysql":
    path        =>  "/usr/bin/mysql",
    command     =>  "/etc/init.d/mysql start",
    refreshonly =>  true,
    subscribe   =>  Exec['Stop mysqld_safe'],
    require     =>  Exec["Stop mysqld_safe"],
  } 
  
  #Now confirm the password, as the one issued in the --skip-grant-tables will be marked as expired
  exec {
    "Confirm password":
    path        =>  "/usr/bin/",
    command     =>  "mysql -uroot -p${password} --connect-expired-password -e\"SET PASSWORD = PASSWORD(\'${password}\');\"",
    refreshonly =>  true,
    subscribe   =>  Exec['Start mysql'],
    require     =>  Exec["Start mysql"],
  }

  #Perform the chkconfig to ensure the service loads on startup?
}
include mysql

define mysql::create_user(
  $dbname = undef,
  $rootusername = undef,
  $rootpassword = undef,
  $dbusername = undef,
  $dbpassword = undef){
  if ($dbname == undef) {
    fail("You must define a database name in order to create a database user")
  }
  if ($rootusername == undef) {
    fail("You must define a root username with admin privileges for the database in order to create a database user")
  }
  if ($rootpassword == undef) {
    fail("You must define a root password with admin privileges for the database in order to create a database user")
  }
  if ($dbusername == undef) {
    fail("You must define a username for the database in order to create a database user")
  }
  if ($dbpassword == undef) {
    fail("You must define a password for the database in order to create a database user")
  }

  exec{"Create_database_user":
    command => "/bin/echo \"CREATE USER '${dbusername}'@'localhost' IDENTIFIED BY '${dbpassword}';\" | mysql -u${rootusername} -p${rootpassword}",
    unless => "mysql -u${dbusername} -p${dbpassword}",
    path => "/usr/bin/", 
  }
  ->
  exec{"Grant_privileges_for_user":
    command => "/bin/echo \"GRANT ALL PRIVILEGES ON ${dbname}.* TO '${dbusername}'@'localhost' WITH GRANT OPTION;\" | mysql -u${rootusername} -p${rootpassword}",
    unless => "/bin/echo \"use ${dbname}\" | mysql -u${dbusername} -p${dbpassword}",
    path => "/usr/bin",
  }  
}

define mysql::create_database(
  $dbname = undef,
  $dbusername = undef,
  $dbpassword = undef,
){
  if ($dbname == undef) {
    fail("You must define a database name in order to create a database")
  }
  if ($dbusername == undef) {
    fail("You must define a username for the database in order to create a database")
  }
  if ($dbpassword == undef) {
    fail("You must define a password for the database in order to create a database")
  }
  
  exec{"Create_database":
    command => "/bin/echo \"create database ${dbname}\" | mysql -u${dbusername} -p${dbpassword}",
    unless => "/bin/echo \"use ${dbname}\" | mysql -u${dbusername} -p${dbpassword}",
    path => "/usr/bin/", 
  }
}

/**
 * Definition for a mysql differential back up call.
 */
define mysql::differential_backup (
  $dbname = undef,
  $dbusername = undef,
  $dbpassword = undef,
  $backup_path = undef,
) {
  if ($dbname == undef) {
    fail("You must define a database name in order to do a differential backup")
  }
  if ($dbusername == undef) {
    fail("You must define a username for the database in order to do a differential backup")
  }
  if ($dbpassword == undef) {
    fail("You must define a password for the database in order to do a differential backup")
  }
  if ($backup_path == undef) {
    fail("You must define a backup path location in order to do a differential backup")
  }
  
  file{"db-${dbname}-backup.sh":
    ensure => present,
    path => "/usr/local/bin/db-${dbname}-backup.sh",
    content => template("${module_name}/db-diff-backup.sh.erb"),
    mode => 0777,
    owner => "vagrant",
    group => "vagrant",
  }
 
  cron{"${dbname}-backup-cron":
    command => "/usr/local/bin/db-${dbname}-backup.sh",
    user => vagrant,
    hour => "*",
    minute => "*",
    require => File["db-${dbname}-backup.sh"]
  }
}

define mysql::differential_restore(
  $dbname = undef,
  $dbusername = undef,
  $dbpassword = undef,
  $backup_path = undef,
){
  if ($dbname == undef) {
    fail("You must define a database name in order to do a differential backup restore")
  }
  if ($dbusername == undef) {
    fail("You must define a username for the database in order to do a differential backup restore")
  }
  if ($dbpassword == undef) {
    fail("You must define a password for the database in order to do a differential backup restore")
  }
  if ($backup_path == undef) {
    fail("You must define a backup path location in order to do a differential backup restore")
  }
  
  #DB restoration
  file{"db-${dbname}-restore.sh":
    ensure => present,
    path => "/usr/local/bin/db-${dbname}-restore.sh",
    content => template("${module_name}/db-diff-restore.sh.erb"),
    mode => 0777,
    owner => "vagrant",
    group => "vagrant",
    
  }

  exec{
    "db-restore":
    require => File["db-${dbname}-restore.sh"],
    command => "/usr/local/bin/db-${dbname}-restore.sh",
    cwd => "/home/vagrant",
  }
}