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
  
  Class['mysql'] -> Class['kanboard']
     
  Package["httpd"] -> Package["php"] ->
  Package["php-mbstring"] -> Package["php-pdo"] ->
  Package["php-gd"] -> Package["php-mysql"]-> 
  Package["unzip"] -> Package["wget"] ->
  Exec["install"] -> Augeas["php.ini"]
  
  file {
    "${local_install_dir}":
    path       =>  "${local_install_dir}",
    ensure     =>  directory,
  }
    
  file{"${httpd_file}":
#    require => File["${local_install_dir}"],
    path => "${local_install_dir}${httpd_file}",
    ensure => present,
    source => ["puppet:///${puppet_file_dir}${httpd_file}"]
  }
   
  package {"httpd":
    ensure => present, #will require the yum / puppet resource package name
    provider => 'yum',
    source => "${local_install_dir}${httpd_file}",
    require => File["${httpd_file}"],
    #version 2.2.15
  }
  package {"php":
    ensure => present,
    provider => 'yum'
    #version 5.3.3
  }
  package {"php-mbstring":
    ensure => present,
    provider => 'yum'
  }  
  package {"php-pdo":
    ensure => present,
    provider => 'yum'
  }
  package {"php-gd":
    ensure => present,
    provider => 'yum'
    #2.0.34
  }
  package {"php-mysql":
    ensure => present,
    provider => 'yum'
    #5.1.73
  }
  package {"unzip":
    ensure => present,
    provider => 'yum'
    #6.00
  }
  package {"wget":
    ensure => present,
    provider => 'yum'
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
  
#  file{"config.php":
#    path => "/var/www/html/kanboard/config.php",
#    content => template("${module_name}/config.default.php.erb"),
#    ensure => present,
#    mode => 0755,
#    owner => "apache",
#    group => "apache",
#    notify => service["httpd"]
#  }

  
  #Need to add date and time to the backup scripts.
  #Need to have the script run on a cron tab
  #/usr/bin/crontab
  # DATE=$(date +"%d-%m-%Y-%H-%M")
  #$(date +"%Y-%m-%d-%H-%M").sql
  
  exec{"Schedule_db_backup":
    require => Exec["install"],
    #command => "mysqldump -u${dbusername} -p${dbpassword} ${dbname} > ${backup_path}$(date +\"%Y-%m-%d-%H-%M\").sql",
    command => "mysqldump -u${dbusername} -p${dbpassword} ${dbname} > ${backup_path}test.sql",
    path => "/usr/bin/", 
  }
  
  notify {
    "Kanboard":
  }
}