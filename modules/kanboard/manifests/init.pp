# Class: kanboard
#
# This module manages kanboard
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class kanboard (
  $backup_path="/vagrant/files/backups/") {
  
  #1. Have unzip operate as an exec call
  #2. Have chown operate as an exec call

  $local_install_path = "/etc/puppet/"
  $local_install_dir = "${local_install_path}installers/"
  $puppet_file_dir = "modules/kanboard/"
  
 $unzip_file = "unzip-6.0-2.el6_6.x86_64.rpm"
  $wget_file = "wget-1.12-5.el6_6.1.x86_64.rpm"
  $patch_file = "patch-2.6-6.el6.x86_64.rpm"
 
  Class["mysql"] -> Class["kanboard"]
  /*
  Package["httpd"] -> Package["php"] ->
  Package["php-mbstring"] -> Package["php-pdo"] ->
#  Package["php-gd"] -> Package["php-mysql"] ->
  Package["php-gd"] -> 
  Package["unzip"] -> Package["wget"] ->
  Package["patch"] ->
  Exec["install"] -> Augeas["php.ini"]
  */
#  file {
#    "${local_install_dir}":
#    path       =>  "${local_install_dir}",
#    ensure     =>  directory,
#  } 
  $apr_file = "apr-1.3.9-5.el6_2.x86_64.rpm"
  file{
    "${local_install_dir}${apr_file}":
    ensure => present,
    path => "${local_install_dir}${apr_file}",
    source => ["puppet:///${puppet_file_dir}${apr_file}"]
  }
  package {"apr":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${apr_file}",
    require => File["${local_install_dir}${apr_file}"]
  }
  $apr_utils_file = "apr-util-1.3.9-3.el6_0.1.x86_64.rpm"
  file{
    "${local_install_dir}${apr_utils_file}":
    ensure => present,
    path => "${local_install_dir}${apr_utils_file}",
    source => ["puppet:///${puppet_file_dir}${apr_utils_file}"]
  }
  package {"apr-util":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${apr_utils_file}",
    require => [File["${local_install_dir}${apr_utils_file}"], Package["apr"]]
  }
  $apr_utils_ldap_file = "apr-util-ldap-1.3.9-3.el6_0.1.x86_64.rpm"
  file{
    "${local_install_dir}${apr_utils_ldap_file}":
    ensure => present,
    path => "${local_install_dir}${apr_utils_ldap_file}",
    source => ["puppet:///${puppet_file_dir}${apr_utils_ldap_file}"]
  }
  package {"apr-util-ldap":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${apr_utils_ldap_file}",
    require => [File["${local_install_dir}${apr_utils_ldap_file}"], Package["apr"], Package["apr-util"]]
  }
  $mail_cap_file = "mailcap-2.1.31-2.el6.noarch.rpm"
  file{
    "${local_install_dir}${mail_cap_file}":
    ensure => present,
    path => "${local_install_dir}${mail_cap_file}",
    source => ["puppet:///${puppet_file_dir}${mail_cap_file}"]
  }
  package {"mailcap":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${mail_cap_file}",
    require => File["${local_install_dir}${mail_cap_file}"]
  }
  $httpd_tools_file = "httpd-tools-2.2.15-47.el6.centos.x86_64.rpm"
  file{
    "${local_install_dir}${httpd_tools_file}":
    ensure => present,
    path => "${local_install_dir}${httpd_tools_file}",
    source => ["puppet:///${puppet_file_dir}${httpd_tools_file}"]
  }
  package {"httpd-tools":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${httpd_tools_file}",
    require => [File["${local_install_dir}${httpd_tools_file}"],Package["apr-util"]]
  }
  $httpd_file = "httpd-2.2.15-47.el6.centos.x86_64.rpm"
  file{
    "${local_install_dir}${httpd_file}":
    ensure => present,
    path => "${local_install_dir}${httpd_file}",
    source => ["puppet:///${puppet_file_dir}${httpd_file}",]
  }
  package {"httpd":
    ensure => present, #will require the yum / puppet resource package name
    provider => 'rpm',
    source => "${local_install_dir}${httpd_file}",
    require => [File["${local_install_dir}${httpd_file}"], Package["apr-util-ldap"], 
    Package["mailcap"], Package["httpd-tools"], Package["apr-util"]],
    #version 2.2.15
  }
  service {
    "httpd":
    require => Package["httpd"],
    ensure => running,
    enable => true
  }
  
  $php_file = "php-5.3.3-46.el6_6.x86_64.rpm"
  $php_cli_file = "php-cli-5.3.3-46.el6_6.x86_64.rpm"
  $php_common_file = "php-common-5.3.3-46.el6_6.x86_64.rpm"
  $php_mbstring_file = "php-mbstring-5.3.3-46.el6_6.x86_64.rpm"
  $php_pdo_file = "php-pdo-5.3.3-46.el6_6.x86_64.rpm"
  $php_gd_file = "php-gd-5.3.3-46.el6_6.x86_64.rpm"
  $php_mysql_file = "php-mysql-5.3.3-46.el6_6.x86_64.rpm"

  file{
    "${local_install_dir}${php_cli_file}":
    ensure => present,
    source => ["puppet:///${puppet_file_dir}${php_cli_file}",]
  }  
  package {"php-cli":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${php_cli_file}",
    require => File["${local_install_dir}${php_cli_file}"],
    #version 5.3.3
  }  
  file{
    "${local_install_dir}${php_common_file}":
    ensure => present,
    source => ["puppet:///${puppet_file_dir}${php_common_file}",]
  }
  package {"php-common":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${php_common_file}",
    require => File["${local_install_dir}${php_common_file}"],
    #version 5.3.3
  }
  file{
    "${local_install_dir}${php_file}":
    ensure => present,
    source => ["puppet:///${puppet_file_dir}${php_file}",]
  }
  package {"php":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${php_file}",
    require => [File["${local_install_dir}${php_file}"], Package["php-common"], Package["php-cli"], Package["httpd"]],
    #version 5.3.3
  }
/* 
  file{
    "${local_install_dir}${php_mbstring_file}":
    ensure => present,
    source => ["puppet:///${puppet_file_dir}${php_mbstring_file}",]
  }
  package {"php-mbstring":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${php_mbstring_file}",
    require => [File["${local_install_dir}${php_mbstring_file}"], Package["php-common"]],
  }  

  file{
    "${local_install_dir}${php_pdo_file}":
    ensure => present,
    source => "puppet:///${puppet_file_dir}${php_pdo_file}",
  }
  package {"php-pdo":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${php_pdo_file}",
    require => [File["${local_install_dir}${php_pdo_file}"],Package["php-common"]],
  }

  file{
    "${local_install_dir}${php_gd_file}":
    ensure => present,
    source => "puppet:///${puppet_file_dir}${php_gd_file}",
  }
  package {"php-gd":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${php_gd_file}",
    require => [File["${local_install_dir}${php_gd_file}"],Package["php-common"]],
    #2.0.34
  } */
/*
  file{
    "${local_install_dir}${php_mysql_file}":
    ensure => present,
    source => "puppet:///${puppet_file_dir}${php_mysql_file}",
  }
  package {"php-mysql":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${php_mysql_file}",
    require => [File["${local_install_dir}${php_mysql_file}"], Class["mysql"]],
    #5.1.73
  }
 */
/*
  file{
    "${local_install_dir}${unzip_file}":
    ensure => present,
    source => "puppet:///${puppet_file_dir}${unzip_file}",
  }
  package {"unzip":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${unzip_file}",
    require => File["${local_install_dir}${unzip_file}"],
    #6.00
  }

  file{
    "${local_install_dir}${wget_file}":
    ensure => present,
    source => "puppet:///${puppet_file_dir}${wget_file}",
  }
  package {"wget":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${wget_file}",
    require => File["${local_install_dir}${wget_file}"],
    #1.12
  }

  file{
    "${local_install_dir}${patch_file}":
    ensure => present,
    source => "puppet:///${puppet_file_dir}${patch_file}",
  }
  package {"patch":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${patch_file}",
    require => File["${local_install_dir}${patch_file}"],
    #1.12
  }

  #Installers
  file{"install.sh":
    ensure => present,
    path => "/usr/local/bin/install.sh",
    source => ["puppet:///${puppet_file_dir}install.sh"],
  }

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }
  
  exec{
    "install":
    require => [Class["mysql"],File["install.sh"],Package["httpd"]],
    command => "/usr/local/bin/install.sh",
    cwd => "/home/vagrant",
  }
    
  augeas { 
    "php.ini":
    context => "/files/etc/php.ini/PHP/",
    changes => [
      "set short_open_tag On",      
    ],
    notify => Service["httpd"],
    require => Package["php"],
  }
  
  $dbtype = "mysql"
  $dbusername = "root"
  $dbpassword = "root"
  $dbname = "kanboard" 
    
  #Need to add date and time to the backup scripts.
  #Need to have the script run on a cron tab
  #/usr/bin/crontab
  # DATE=$(date +"%d-%m-%Y-%H-%M")
  #$(date +"%Y-%m-%d-%H-%M").sql
  
  exec{"Create_db_table":
    require => Exec["install"],
    #command => "mysqldump -u${dbusername} -p${dbpassword} ${dbname} > ${backup_path}$(date +\"%Y-%m-%d-%H-%M\").sql",
    command => "/bin/echo \"create database kanboard\" | mysql -uroot -proot",
    unless => "/bin/echo \"use kanboard\" | mysql -uroot -proot",
    path => "/usr/bin/", 
  }

#  exec{"Update_db_table":
#    require => Exec["Create_db_table"],
#    #command => "mysqldump -u${dbusername} -p${dbpassword} ${dbname} > ${backup_path}$(date +\"%Y-%m-%d-%H-%M\").sql",
#    command => "mysql -uroot -proot kanboard < ${backup_path}2015-10-25-kanboardbackup.sql",
#    path => "/usr/bin/",
#    notify => Service["httpd"],
#  }
  
  file{"config.php":
    require => Exec["install"],
    path => "/var/www/html/kanboard/config.php",
    content => template("${module_name}/config.default.php.erb"),
    ensure => present,
    mode => 0755,
    owner => "apache",
    group => "apache",
    notify => Service["httpd"]
  }
  
#  exec{"Schedule_db_backup":
#    require => Exec["Update_db_table"],
#    command => "mysqldump -u${dbusername} -p${dbpassword} ${dbname} > ${backup_path}$(/bin/date +%Y-%m-%d-%H-%M)-kanboardbackup.sql",
#    path => "/usr/bin/", 
#  }
  
 */
  notify {
    "Kanboard":
  }
}