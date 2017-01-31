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
){  
  #Modify this into a class that we can pass args into, e.g. mysql version number, os speciic installer classes etc.
  #NOTE: This script will reset the root password if it cannot login to the mysql service
  $local_install_dir    = "${local_install_path}installers"
  $puppet_file_dir      = "modules/mysql/"

  $major_version        = "5"
  $minor_version        = "7"
  $patch_version        = "13"
  $os = "$operatingsystem$operatingsystemmajrelease"
  
  if "${os}" == "CentOS7"{
    $os_platform          = "-1.el7.x86_64"
    $file_location = ""
  } elsif "${os}" == "CentOS6" {
    $os_platform          = "-1.el6.x86_64"
    $file_location = "${operatingsystem}/${operatingsystemmajrelease}/"
  }

  $MySQL_common = "mysql-community-common-${major_version}.${minor_version}.${patch_version}${os_platform}.rpm"
  $MySQL_server = "mysql-community-server-${major_version}.${minor_version}.${patch_version}${os_platform}.rpm"
  $MySQL_client = "mysql-community-client-${major_version}.${minor_version}.${patch_version}${os_platform}.rpm"
  $MySQL_libs   = "mysql-community-libs-${major_version}.${minor_version}.${patch_version}${os_platform}.rpm"
  $MySQL_shared_compat = "mysql-community-libs-compat-${major_version}.${minor_version}.${patch_version}${os_platform}.rpm"

  #Load the installers from the puppet fileserver into the local filesystem
  #Try giving the file a name and separate target location so we don't need to fully qualify the path
  
  #Ensure that the local install directory exists
  #Ensure the destination directory for the installers is present

  if "${os}" == "CentOS7"{
    #  install libaio as it is needed by mysql-server package
    $libaio = "libaio-0.3.109-13.el7.x86_64.rpm"
    file {
        "${libaio}":
        path    =>  "${local_install_dir}/${libaio}",
        ensure  =>  present,
        source  =>  ["puppet:///${puppet_file_dir}${file_location}${libaio}"],
    }
    package {
      'libaio':
      ensure      =>  installed,
      provider    =>  'rpm',
      source      =>  "${local_install_dir}/${libaio}",
      require     =>  File["${libaio}"],
      before      =>  [Package['mysql-community-common'], Package['mysql-community-server'], Package['mysql-community-client']],
    }
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
      source  =>  ["puppet:///${puppet_file_dir}${file_location}${MySQL_common}"],
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
    source      =>  ["puppet:///${puppet_file_dir}${file_location}${MySQL_libs}"],
  }
  
  package {
    'mysql-community-libs':
    ensure      =>  installed,
    provider    =>  'rpm',
    source      =>  "${local_install_dir}/${MySQL_libs}",
    require     =>  [File["${MySQL_libs}"], Package["mysql-community-common"]],
  }
  
  file {
      "${MySQL_shared_compat}":
      path    =>  "${local_install_dir}/${MySQL_shared_compat}",
      ensure  =>  present,
      source  =>  ["puppet:///${puppet_file_dir}${file_location}${MySQL_shared_compat}"],
  }
  
  package {
      'mysql-community-libs-compat':
      ensure      =>  installed,
      provider    =>  'rpm',
      source      =>  "${local_install_dir}/${MySQL_shared_compat}",
      require     =>  [File["${MySQL_shared_compat}"],
        Package["mysql-community-libs"]
      ],
  }  
  
  file{
    "${MySQL_client}":
    path      => "${local_install_dir}/${MySQL_client}",
    ensure    => present,
    source    => ["puppet:///${puppet_file_dir}${file_location}${MySQL_client}"],
  }
  
  package {
    'mysql-community-client':
    ensure      =>  installed,
    provider    =>  'rpm',
    source      =>  "${local_install_dir}/${MySQL_client}",
    require     =>  [File["${MySQL_client}"]], 
  }
  
  file {
    "${MySQL_server}":
    path    =>  "${local_install_dir}/${MySQL_server}",
    ensure  =>  present,
    source  =>  ["puppet:///${puppet_file_dir}${file_location}${MySQL_server}"],
  }
  
  package {
    'mysql-community-server':
    ensure      =>  installed,
    provider    =>  'rpm',
    source      =>  "${local_install_dir}/${MySQL_server}",
    require     =>  [File["${MySQL_server}"], 
    Package["mysql-community-client"], 
    Package["mysql-community-common"]], 
  }

  notify{"Starting mysqld":
    require => Package["mysql-community-server"]
  }

  if "${os}" == "CentOS7"{
    exec {"Start mysqld":
      path => "/usr/bin/",
      command => "systemctl start mysqld", #centos 7
      require => Notify["Starting mysqld"]
    }
  } elsif "${os}" == "CentOS6" {
    exec {"Start mysqld part une":
      command => "/etc/init.d/mysqld start & /bin/sleep 10", #centos 6
      path => "/usr/bin/",
      require => Notify["Starting mysqld"]
    }

    exec {"Start mysqld":
      command => "/etc/init.d/mysqld start", #centos 6
      path => "/usr/bin/",
      require => [Notify["Starting mysqld"],Exec["Start mysqld part une"]]
    }
  }

  #1. Find the previous password in the my.cnf
  #2. If .my.cnf doesn't exist then find the temporary password
  #3. Set the new root password
  #4. Set root password in the my.cnf template file and place it in the /home/root directory
  #5. Create regular mysql users using the root user, not sure if vagrant can do this?
  
   exec {"reset temp password":
    path => "/usr/bin/",
    onlyif => "test ! -f ${root_home}/.my.cnf",
    command => "mysqladmin -uroot --password=\$(sudo grep 'temporary password' /var/log/mysqld.log | awk '{print \$11}') password '${password}'",
    require => Exec["Start mysqld"],
    before => File["my.cnf"],
  }

   exec {"reset password":
    path => "/usr/bin/",
    onlyif => "test -f ${root_home}/.my.cnf",
    command => "mysqladmin -uroot --password=\$(sudo grep 'password=' ${root_home}/.my.cnf | awk '{print \$2}') password '${password}'",
    require => Exec["Start mysqld"],
    before => File["my.cnf"],
  }
  
  #if we can login with the expected password then do nothing, if not then we need to add it to the .my.cnf file.
  file {
    "my.cnf":
    path    => "${root_home}/.my.cnf",
    ensure  =>  present,
    mode => 0655,
    content => template("${module_name}/my.cnf.erb"),
    require => Exec["Start mysqld"]
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
