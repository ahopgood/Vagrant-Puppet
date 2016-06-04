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
  $backup_path="/vagrant/files/backups/",
  $major_version = "1",
  $minor_version = "0",
  $patch_version = "19"  
  ) {
  
  $dbtype = "mysql"
  $dbusername = "root"
  $dbpassword = "root"
  $dbname = "kanboard" 

  $local_install_path = "/etc/puppet/"
  $local_install_dir = "${local_install_path}installers/"
  $puppet_file_dir = "modules/${module_name}/"
     
  notify {
    "${module_name} installation completed":
  }  

#  Class["php"]
#  ->  
#  Class["kanboard"]
 
  $unzip_file = "unzip-6.0-2.el6_6.x86_64.rpm"
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
  }
  
  $wget_file = "wget-1.12-5.el6_6.1.x86_64.rpm"
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

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

  $kanboard_file = "kanboard-${major_version}-${minor_version}-${patch_version}.zip"

  file{
    "${kanboard_file}":
    ensure => present,
    path => "/var/www/html/${kanboard_file}",
    source => ["puppet:///${puppet_file_dir}${kanboard_file}"],
    require => Class["php"],
  }

  exec{
    "unzip":
    require => [Package["unzip"],File["${kanboard_file}"]],
    command => "unzip -u /var/www/html/${kanboard_file}",
    cwd => "/var/www/html",
  }
  
  exec{
    "chown":
    require => Exec["unzip"],
    command => "chown -R apache:apache kanboard/data",
    cwd => "/var/www/html",
  }

  php::php_ini_file{"php.ini":
    changes => ["set short_open_tag On"],
  }
  
  Class["mysql"]
  ->
  mysql::create_database{
    "create_lanboard_database":
    dbname => "${dbname}",
    dbusername => "${dbusername}",
    dbpassword => "${dbpassword}",
  }
  ->
  mysql::differential_restore{
    "kanboard_database_restore":
    dbname => "${dbname}",
    dbusername => "${dbusername}",
    dbpassword => "${dbpassword}",
    backup_path => "/vagrant/backups/",
  }
  ->
  mysql::differential_backup{
    "kanboard_database_backup":
    dbname => "${dbname}",
    dbusername => "${dbusername}",
    dbpassword => "${dbpassword}",
    backup_path => "/vagrant/backups/",
    hour => "*",
    minute => "0",
  }
  ->
  file{"config.php":
    path => "/var/www/html/kanboard/config.php",
    content => template("${module_name}/config.default.php.erb"),
    ensure => present,
    mode => 0755,
    owner => "apache",
    group => "apache",
    require => Exec["chown"]
  }
  
  exec {
    "restart_apache_for_kanban":
    require => File["config.php"],
    command => "/etc/init.d/httpd restart",
    cwd => "/usr/bin/",
  } 
  
  notify {
    "Kanboard":
  }
}

