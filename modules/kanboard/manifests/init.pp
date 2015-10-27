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
  $backup_path="/vagrant/files/") {
  
  $local_install_path = "/etc/puppet/"
  $local_install_dir = "${local_install_path}installers/"
  $puppet_file_dir = "modules/kanboard/"
  $httpd_file = "httpd-2.2.15-47.el6.centos.x86_64.rpm"
  $php_file = "php-5.3.3-46.el6_6.x86_64.rpm"
  $php_gd_file = "php-gd-5.3.3-46.el6_6.x86_64.rpm"
  $php_mbstring_file = "php-mbstring-5.3.3-46.el6_6.x86_64.rpm"
  $php_mysql_file = "php-mysql-5.3.3-46.el6_6.x86_64.rpm"
  $php_pdo_file = "php-pdo-5.3.3-46.el6_6.x86_64.rpm"
  $unzip_file = "unzip-6.0-2.el6_6.x86_64.rpm"
  $wget_file = "wget-1.12-5.el6_6.1.x86_64.rpm"

  
  Package["httpd"] -> Package["php"] ->
  Package["php-mbstring"] -> Package["php-pdo"] ->
  Package["php-gd"] -> Package["php-mysql"]-> 
  Package["unzip"] -> Package["wget"] ->
  Exec["install"] -> Augeas["php.ini"]
  
#  file {
#    "${local_install_dir}":
#    path       =>  "${local_install_dir}",
#    ensure     =>  directory,
#  }
    
  file{
    ["${local_install_dir}${httpd_file}", 
    "${local_install_dir}${php_file}",
    "${local_install_dir}${php_gd_file}",
    "${local_install_dir}${php_mbstring_file}",
    "${local_install_dir}${$php_mysql_file}",
    "${local_install_dir}${php_pdo_file}",
    "${local_install_dir}${unzip_file}",
    "${local_install_dir}${wget_file}"]:
#    require => File["${local_install_dir}"],
#    path => "${local_install_dir}",
    ensure => present,
    source => ["puppet:///${puppet_file_dir}${httpd_file}",
      "puppet:///${puppet_file_dir}${php_file}",
      "puppet:///${puppet_file_dir}${php_gd_file}",
      "puppet:///${puppet_file_dir}${php_mbstring_file}",
      "puppet:///${puppet_file_dir}${$php_mysql_file}",
      "puppet:///${puppet_file_dir}${php_pdo_file}",
      "puppet:///${puppet_file_dir}${unzip_file}",
      "puppet:///${puppet_file_dir}${wget_file}"]
  }
   
  package {"httpd":
    ensure => present, #will require the yum / puppet resource package name
    provider => 'yum',
    source => "${local_install_dir}${httpd_file}",
    require => File["${local_install_dir}${httpd_file}"],
    #version 2.2.15
  }
  package {"php":
    ensure => present,
    provider => 'yum',
    source => "${local_install_dir}${httpd_file}",
    require => File["${local_install_dir}${httpd_file}"],
    #version 5.3.3
  }
  package {"php-mbstring":
    ensure => present,
    provider => 'yum',
    source => "${local_install_dir}${httpd_file}",
    require => File["${local_install_dir}${httpd_file}"],
  }  
  package {"php-pdo":
    ensure => present,
    provider => 'yum',
    source => "${local_install_dir}${httpd_file}",
    require => File["${local_install_dir}${httpd_file}"],
  }
  package {"php-gd":
    ensure => present,
    provider => 'yum',
    source => "${local_install_dir}${httpd_file}",
    require => File["${local_install_dir}${httpd_file}"],
    #2.0.34
  }
  package {"php-mysql":
    ensure => present,
    provider => 'yum',
    source => "${local_install_dir}${httpd_file}",
    require => File["${local_install_dir}${httpd_file}"],
    #5.1.73
  }
  package {"unzip":
    ensure => present,
    provider => 'yum',
    source => "${local_install_dir}${httpd_file}",
    require => File["${local_install_dir}${httpd_file}"],
    #6.00
  }
  package {"wget":
    ensure => present,
    provider => 'yum',
    source => "${local_install_dir}${httpd_file}",
    require => File["${local_install_dir}${httpd_file}"],
    #1.12
  }
  
  file{"install.sh":
    ensure => present,
    path => "/usr/local/bin/install.sh",
    source => ["puppet:///${puppet_file_dir}install.sh"]
  }

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }
  
  exec{
    "install":
    require => Class["mysql"],
    command => "/usr/local/bin/install.sh",
    cwd => "/home/vagrant",
    notify => Service["httpd"]
  }
  
  service {
    "httpd":
    ensure => running,
    enable => true
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

  exec{"Update_db_table":
    require => Exec["Create_db_table"],
    #command => "mysqldump -u${dbusername} -p${dbpassword} ${dbname} > ${backup_path}$(date +\"%Y-%m-%d-%H-%M\").sql",
    command => "mysql -uroot -proot kanboard < ${backup_path}2015-10-25-kanboardbackup.sql",
    path => "/usr/bin/",
    notify => Service["httpd"],
  }
  
  file{"config.php":
    require => Exec["Update_db_table"],
    path => "/var/www/html/kanboard/config.php",
    content => template("${module_name}/config.default.php.erb"),
    ensure => present,
    mode => 0755,
    owner => "apache",
    group => "apache",
    notify => service["httpd"]
  }
  
  exec{"Schedule_db_backup":
    require => Exec["Update_db_table"],
    #command => "mysqldump -u${dbusername} -p${dbpassword} ${dbname} > ${backup_path}$(date +\"%Y-%m-%d-%H-%M\").sql",
    command => "mysqldump -u${dbusername} -p${dbpassword} ${dbname} > ${backup_path}test.sql",
    path => "/usr/bin/", 
  }
  

  notify {
    "Kanboard":
  }
}