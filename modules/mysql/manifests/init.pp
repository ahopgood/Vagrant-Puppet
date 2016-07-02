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
  $local_install_dir    = "${local_install_path}installers"
  $puppet_file_dir      = "modules/mysql/"
  
#  $major_version        = "5"
#  $minor_version        = "6"
#  $patch_version        = "19"
#  $os_platform          = "-1.el6.x86_64"
  
  $major_version        = "5"
  $minor_version        = "7"
  $patch_version        = "13"
  $os_platform          = "-1.el6.x86_64"
#  $os_platform          = "-1.el7.x86_64"

#  $MySQL_shared_compat  = "MySQL-shared-compat-${major_version}.${minor_version}.${patch_version}${os_platform}.rpm"
#  $MySQL_server         = "MySQL-server-${major_version}.${minor_version}.${patch_version}${os_platform}.rpm"
#  $MySQL_client         = "MySQL-client-${major_version}.${minor_version}.${patch_version}${os_platform}.rpm"
#  $MySQL_shared         = "MySQL-shared-${major_version}.${minor_version}.${patch_version}${os_platform}.rpm"

  $MySQL_common = "mysql-community-common-${major_version}.${minor_version}.${patch_version}${os_platform}.rpm"
  $MySQL_server = "mysql-community-server-${major_version}.${minor_version}.${patch_version}${os_platform}.rpm"
  $MySQL_client = "mysql-community-client-${major_version}.${minor_version}.${patch_version}${os_platform}.rpm"
  $MySQL_libs   = "mysql-community-libs-${major_version}.${minor_version}.${patch_version}${os_platform}.rpm"

  $password             = "rootR00?"

  #Load the installers from the puppet fileserver into the local filesystem
  #Try giving the file a name and separate target location so we don't need to fully qualify the path
  
  #Ensure that the local install directory exists
  #Ensure the destination directory for the installers is present
  $os = "$operatingsystem$operatingsystemmajrelease"
    
  if "${os}" == "CentOS7"{
    #  install libaio as it is needed by mysql-server package
    $libaio = "libaio-0.3.109-13.el7.x86_64.RPM"
    file {
        "${libaio}":
        path    =>  "${local_install_dir}/${libaio}",
        ensure  =>  present,
        source  =>  ["puppet:///${puppet_file_dir}${libaio}"],
    }
  
    package {
      'libaio':
      ensure      =>  installed,
      provider    =>  'rpm',
      source      =>  "${local_install_dir}/${libaio}",
      require     =>  File["${libaio}"],
      before      =>  [Package['mysql-community-common'], Package['mysql-community-server'], Package['mysql-community-client']],
    }
#  remove mariadb-libs.x86_64 1:5.5.41-2.el7_0
    package {
      "postfix":
      ensure    => absent,
      provider  => 'rpm',
    } 
    
    package {
      'mariadb-libs':
      ensure      =>  absent,
      provider    =>  'rpm',
      before      =>  [Package['mysql-community-common'], Package['mysql-community-server'], Package['mysql-community-client']],
      require     =>  Package["postfix"]
    }
  } elsif "${os}" == "CentOS6" {
    
    package {"mysql-libs":
      provider => "rpm",
      ensure => absent,
      before => Package["mysql-community-common"],
      uninstall_options => ["--nodeps"]
    }
  }

  file {
      "${MySQL_common}":
      path    =>  "${local_install_dir}/${MySQL_common}",
      ensure  =>  present,
      source  =>  ["puppet:///${puppet_file_dir}${MySQL_common}"],
  }
  
  package {
      'mysql-community-common':
      ensure      =>  installed,
      provider    =>  'rpm',
      source      =>  "${local_install_dir}/${MySQL_common}",
      require     =>  [File["${MySQL_common}"]],
  }
  
  file {
    "${MySQL_libs}":
    path        => "${$local_install_dir}/${MySQL_libs}",
    ensure      =>  present,
    source      =>  ["puppet:///${puppet_file_dir}${MySQL_libs}"],
  }
  
  package {
    'mysql-community-libs':
    ensure      =>  installed,
    provider    =>  'rpm',
    source      =>  "${local_install_dir}/${MySQL_libs}",
    require     =>  [File["${MySQL_libs}"], Package["mysql-community-common"]],
  }
  
  file{
    "${MySQL_client}":
    path      => "${local_install_dir}/${MySQL_client}",
    ensure    => present,
    source    => ["puppet:///${puppet_file_dir}${MySQL_client}"],
  }
  
  package {
    'mysql-community-client':
    ensure      =>  installed,
    provider    =>  'rpm',
    source      =>  "${local_install_dir}/${MySQL_client}",
    require     =>  [File["${MySQL_client}"], Package["mysql-community-libs"]],
  }
  
  file {
    "${MySQL_server}":
    path    =>  "${local_install_dir}/${MySQL_server}",
    ensure  =>  present,
    source  =>  ["puppet:///${puppet_file_dir}${MySQL_server}"],  
  }
  
  package {
    'mysql-community-server':
    ensure      =>  installed,
    provider    =>  'rpm',
    source      =>  "${local_install_dir}/${MySQL_server}",
    require     =>  [File["${MySQL_server}"], 
    Package["mysql-community-client"], 
    Package["mysql-community-common"]], 
#    Package["libaio"]],
  }
  
  #causes puppet to hang on Centos 6.6
#  service {"mysqld":
#    enable => true,
#    ensure => running,
#    require => Package["mysql-community-server"]
#  }

#  exec {"Stop mysqld":
#    path => "/usr/sbin/",
#    command => "service mysqld stop",
##    command => "service mysqld start",
#    require => Package["mysql-community-server"]
#  }

  notify{"Starting mysqld":
    require => Package["mysql-community-server"]
  }
  exec {"Start mysqld":
    path => "/usr/sbin/",
    command => "/etc/init.d/mysqld start &",
#    command => "service mysqld start",
#    require => Package["mysql-community-server"]
    require => Notify["Starting mysqld"]
  }
  
    exec {"Stop mysqld":
    path => "/usr/sbin/",
    command => "/etc/init.d/mysqld stop",
#    command => "service mysqld stop",
#    command => "service mysqld start",
#    require => Package["mysql-community-server"]
    require => Exec["Start mysqld"] #otherwise making mysqld_safe the first run will result in being unable to start the server again via service mysqld start
  }

  file {
    "defaults-file":
    path    => "${local_install_dir}/root.txt",
    ensure  =>  present,
    mode => 0644,
    source  => ["puppet:///${puppet_file_dir}root.txt"],
#    require => Exec["Start mysqld"] #otherwise making mysqld_safe the first run will result in being unable to start the server again via service mysqld start
    require => Exec["Stop mysqld"]
#        require => Package["mysql-community-server"]
  }

  exec {"Set password via mysqld_safe":
    path => "/usr/bin/",
    command => "sudo /usr/bin/mysqld_safe --init-file=${local_install_dir}/root.txt &",
# /usr/bin/mysqld_safe --init-file=/etc/puppet/installers/root.txt
#    command => "/usr/bin/mysqld_safe",
#    command => "service mysqld start",
#    require => Package["mysql-community-server"],
    require => File["defaults-file"],
  }
  
  #stop the service again to drop out of safe mode
#  exec {
#    "Stop mysqld_safe":
##    path        =>  "/usr/sbin/mysql",
#    path        =>  "/usr/bin/",
#    command     =>  "/usr/bin/mysqld_safe stop",
##    refreshonly =>  true,
##    subscribe   =>  Exec['Set MySQL root password'],
##    require     =>  Exec['Set MySQL root password'],
##    subscribe => Exec['Skip grant tables'],
##    require     =>  Exec['Skip grant tables'],
#     require =>  Exec["Set password via mysqld_safe"],
#  }
#  
#    exec {
#    "Start mysql":
#    path        =>  "/usr/bin/mysql",
#    command     =>  "/etc/init.d/mysqld start",
#    refreshonly =>  true,
#    subscribe   =>  Exec['Stop mysqld_safe'],
#    require     =>  Exec["Stop mysqld_safe"],
#  }

#  exec {"Start mysqld":
#    path => "/sbin/",
#    command => "service mysqld start &",
##    command => "service mysqld start",
#    require => Package["mysql-community-server"]
#  }
#  
#  file {
#    "defaults-file":
#    path    => "${local_install_dir}/my.conf",
#    ensure  =>  present,
#    mode => 0644,
#    source  => ["puppet:///${puppet_file_dir}my.conf"],
#    require => Exec["Start mysqld"]
#  }
#  
#  exec {"Setup defaults-file":
#    path => "/usr/bin/",
#    command => "sudo echo \"password='$(sudo grep 'temporary password' /var/log/mysqld.log | awk '{print \$11}')'\" >> ${local_install_dir}/my.conf",
#    require => File["defaults-file"],
#  }
#  
#  exec {"Reset temporary password":
#    path => "/usr/bin/",
#    #command => "sleep 15 mysqladmin -uroot -p$(sudo grep 'temporary password' /var/log/mysqld.log | awk '{print \$11}') password 'rootR00?' > /dev/null 2>&1",
#    #command => "sudo mysql -uroot -p$(sudo grep 'temporary password' /var/log/mysqld.log | awk '{print $11}') --connect-expired-password -e\" set password=PASSWORD('rootR00?');\"",
#    #command => "sudo mysql -uroot -p$(sudo grep 'temporary password' /var/log/mysqld.log | awk '{print \$11}') --connect-expired-password -e\"ALTER USER 'root'@'localhost' IDENTIFIED BY 'rootR00?';\"",
#    command => "mysql --defaults-file=${local_install_dir}/my.conf -e\"ALTER USER 'root'@'localhost' IDENTIFIED BY 'rootR00?';\"",
#    require => Exec["Setup defaults-file"],
##    require => Service["mysqld"],
##    returns => 1, #as we get warnings about using a password on the command line
#  }
#mysqladmin -uroot -p$(sudo grep 'temporary password' /var/log/mysqld.log | awk '{print $11}') password rootR00? > /dev/null 2>&1
#  sudo mysql -uroot -p $(sudo grep 'temporary password' /var/log/mysqld.log | awk '{print $11}') --connect-expired-password -e" set password=PASSWORD('rootR00?')";
#  sudo mysql -uroot -p --connect-expired-password -e" set password=PASSWORD('rootR00?')";
  
#  sudo grep 'temporary password' /var/log/mysqld.log
#  sudo grep 'temporary password' /var/log/mysqld.log | awk '{print $11}'
  
  
  #Need to check the service is running first
#  exec {
#    "Stop mysql":
#    #refreshonly =>  true,
#    #subscribe   =>  [Package['MySQL-client'], Package['MySQL-server'], Package['MySQL-shared']],
#    unless      =>  "/usr/bin/mysqladmin -uroot -p${password} status",
#    path        =>  "/usr/bin/mysqld",
#    command     =>  "/etc/init.d/mysqld stop",
#  #  before      =>  Exec['Skip grant tables'],  
#  }
  
  #Start the service in safe mode
#  exec {
#    "Skip grant tables":
#    path        =>  "/usr/bin/",
#    unless      =>  "/usr/bin/mysqladmin status",
#    command     =>  "sudo mysqld_safe --skip-grant-tables -e \"ALTER USER 'root'@'localhost' IDENTIFIED BY '${password}';\"", 
#    #before      =>  Exec['Set MySQL root password'],
#    refreshonly =>  true,
#    subscribe   =>  Exec['Stop mysql'],
#    require     =>  Exec['Stop mysql'],
#  }
  
  #Set the root password
#  exec {
#    "Set MySQL root password":
#    path        =>  "/usr/bin/",
##    command     =>  "sudo sleep 5 && mysql mysql -e \"update user set password=PASSWORD('$password') where user='root'; flush privileges;\"",
#    command => "sudo sleep 15 && mysql mysql -e \"ALTER USER 'root'@'localhost' IDENTIFIED BY '$password';\"",
#    refreshonly =>  true,
#    subscribe   =>  Exec['Skip grant tables'],
#    require     =>  Exec['Skip grant tables'],  
#  }

  
#  #Start service again normally without skipping the grant tables.
#  exec {
#    "Start mysql":
#    path        =>  "/usr/bin/mysql",
#    command     =>  "/etc/init.d/mysqld start",
#    refreshonly =>  true,
#    subscribe   =>  Exec['Stop mysqld_safe'],
#    require     =>  Exec["Stop mysqld_safe"],
#  } 
  
  #Now confirm the password, as the one issued in the --skip-grant-tables will be marked as expired
#  exec {
#    "Confirm password":
#    path        =>  "/usr/bin/",
#    command     =>  "mysql -uroot -p${password} --connect-expired-password -e\"SET PASSWORD = PASSWORD(\'${password}\');\"",
#    refreshonly =>  true,
#    subscribe   =>  Exec['Start mysql'],
#    require     =>  Exec["Start mysql"],
#  }
}

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
#    require => Class["mysql"]
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