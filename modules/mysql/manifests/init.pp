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
class mysql (
  $password = "rootR00?s",
  $root_home = "/home/vagrant",
  $major_version        = "5",
  $minor_version        = "7",
  $patch_version        = "13",
){  
  #Modify this into a class that we can pass args into, e.g. mysql version number, os speciic installer classes etc.
  #NOTE: This script will reset the root password if it cannot login to the mysql service
  $local_install_dir    = "${local_install_path}installers"
  $puppet_file_dir      = "modules/mysql/"

  $os = "$operatingsystem$operatingsystemmajrelease"
  notify{"Found ${os}":}

  if (versioncmp("${memorysize_mb}", "512.00") < 0){
    fail("We need a machine with more than 1000.00 MB of memory found only [${memorysize_mb}]")
  }

  if "${os}" == "CentOS7"{
    class{"mysql::centos":
      major_version => $major_version,
      minor_version => $minor_version,
      patch_version => $patch_version,
      password => $password,
      root_home => $root_home,
    }
    contain mysql::centos
  } elsif "${os}" == "CentOS6" {
    class{"mysql::centos":
      major_version => $major_version,
      minor_version => $minor_version,
      patch_version => $patch_version,
      password => $password,
      root_home => $root_home,
    }
    contain mysql::centos
  } elsif ("${os}" == "Ubuntu15.10"){
    class{"mysql::ubuntu":
      major_version => $major_version,
      minor_version => $minor_version,
      patch_version => $patch_version,
      password => $password,
      root_home => $root_home,
    }
    contain mysql::ubuntu
  }
}
#sudo /usr/bin/mysqld_safe --init-file=/etc/puppet/installers/root.txt
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

  exec{"Create_database_user ${dbusername}":
    command => "/bin/echo \"CREATE USER '${dbusername}'@'localhost' IDENTIFIED BY '${dbpassword}';\" | mysql -u${rootusername} -p${rootpassword}",
    unless => "mysql -u${dbusername} -p${dbpassword}",
    path => "/usr/bin/",
    require => [Service["mysql"], Exec["confirm root password"]]
  }
  ->
  exec{"Grant_privileges_for_user ${dbusername}":
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
  
  exec{"Create_database ${dbname}":
    command => "/bin/echo \"create database ${dbname}\" | mysql -u${dbusername} -p${dbpassword}",
    unless => "/bin/echo \"use ${dbname}\" | mysql -u${dbusername} -p${dbpassword}",
    path => "/usr/bin/",
    require => [Service["mysql"], Exec["confirm root password"]]
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
  $hour = "*",
  $minute = "*",
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
    hour => "${hour}",
    minute => "${minute}",
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
  
#  Class["patch"] -> Define["mysql::differential_restore"] 
  include patch
  #DB restoration
  file{"db-${dbname}-restore.sh":
    ensure => present,
    path => "/usr/local/bin/db-${dbname}-restore.sh",
    content => template("${module_name}/db-diff-restore.sh.erb"),
    mode => 0777,
    owner => "vagrant",
    group => "vagrant",
#    require => Package["patch"],
  }

  exec{
    "db-restore":
    require => File["db-${dbname}-restore.sh"],
    command => "/usr/local/bin/db-${dbname}-restore.sh",
    cwd => "/home/vagrant",
  }
}

/*
* Definition to provide a MySQL connector in Java, also known as j/connector.
* Defaults to version 5.1.40
*/
define mysql::connector::java (
  $major_version = "5",
  $minor_version = "1",
  $patch_version = "40",
  $destination_path = undef,
){

  if ($destination_path == undef){
    fail("A destination_path parameter is required.")
  }
  $puppet_file_dir = "modules/${module_name}/"
  $java_connector = "mysql-connector-java-${major_version}.${minor_version}.${patch_version}"
  $java_connector_archive = "${java_connector}.tar.gz"
  $java_connector_jar = "${java_connector}-bin.jar"

  file {"j-connector-archive ${destination_path}":
    ensure => present,
    source => ["puppet:///${puppet_file_dir}${java_connector_archive}"],
    path => "${destination_path}${java_connector_archive}",
#    require => File["${local_install_dir}"]
  }

  exec {"Unpack j-connector archive for ${destination_path}":
    path      =>  "/bin/",
    cwd       =>  "${destination_path}",
    command   =>  "/bin/tar xfvz ${destination_path}${java_connector_archive}",
    require   =>  File[ "j-connector-archive ${destination_path}" ],
  }

  file { "${destination_path}${java_connector_jar}":
    ensure => present,
    source => "${destination_path}${java_connector}/${java_connector_jar}",
    path => "${destination_path}${java_connector_jar}",
    require => Exec["Unpack j-connector archive for ${destination_path}"],
  }

  file {"remove unpacked j-connector archive directory ${destination_path}":
    ensure => absent,
    force => true,
    path => "${destination_path}${java_connector}",
    require => [Exec["Unpack j-connector archive for ${destination_path}"],
      File["j-connector-archive ${destination_path}"],
      File[ "${destination_path}${java_connector_jar}"],
    ]
  }

  exec {"remove j-connector archive directory ${destination_path}":
    path => "/bin/",
    command => "rm ${destination_path}${java_connector_archive}",
    require => [File["remove unpacked j-connector archive directory ${destination_path}"],
    ]
  }
}