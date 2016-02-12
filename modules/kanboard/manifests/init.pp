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
  

#  Package["httpd"] -> Package["php"] ->
#  Package["php-mbstring"] -> Package["php-pdo"] ->
#  Package["php-gd"] -> Package["php-mysql"] ->
#  Package["php-gd"] -> 
#  Package["unzip"] -> Package["wget"] ->
#  Package["patch"] ->
#  Exec["install"] -> Augeas["php.ini"]

#  file {
#    "${local_install_dir}":
#    path       =>  "${local_install_dir}",
#    ensure     =>  directory,
#  }
#  -> Package["unzip"]
 
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
    #6.00
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

  $patch_file = "patch-2.6-6.el6.x86_64.rpm"
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
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

  $kanboard_file = "kanboard-${major_version}-${minor_version}-${patch_version}.zip"

  file{
    "${kanboard_file}":
#    require => Package["httpd"],
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
#  augeas { 
#    "php.ini":
#    context => "/files/etc/php.ini/PHP/",
#    changes => [
#      "set short_open_tag On",      
#    ],
#    notify => Service["httpd"],
#    #require => Package["php"], 
#    #supplanted by the Class["php"] declaration but useful to know if this augeas call is externalised.
#  }
        
  exec{"Create_db_table":
    require => Exec["chown"],
    command => "/bin/echo \"create database ${dbname}\" | mysql -u${dbusername} -p${dbpassword}",
    unless => "/bin/echo \"use ${dbname}\" | mysql -u${dbusername} -p${dbpassword}",
    path => "/usr/bin/", 
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
    require => [Exec["Create_db_table"],File["db-${dbname}-restore.sh"]],
    command => "/usr/local/bin/db-${dbname}-restore.sh",
    cwd => "/home/vagrant",
  }

 #DB backup
  file{"db-${dbname}-backup.sh":
    ensure => present,
    path => "/usr/local/bin/db-${dbname}-backup.sh",
    content => template("${module_name}/db-diff-backup.sh.erb"),
    mode => 0777,
    owner => "vagrant",
    group => "vagrant",
    require => Exec["db-restore"]
  }
 
  cron{"${dbname}-backup-cron":
    command => "/usr/local/bin/db-${dbname}-backup.sh",
    user => vagrant,
    hour => "*",
    minute => "*",
    require => File["db-${dbname}-backup.sh"]
  }
  
#  file{"httpd_hosted_content":
#      path => "/var/www/html/kanboard/config.php",
#      content => template("${module_name}/config.default.php.erb"),
#      ensure => present,
#      mode => 0755,
#      owner => "apache",
#      group => "apache",
#      require => Exec["chown"]
#  }

  file{"config.php":
    require => Exec["db-restore"],
    path => "/var/www/html/kanboard/config.php",
    content => template("${module_name}/config.default.php.erb"),
    ensure => present,
    mode => 0755,
    owner => "apache",
    group => "apache",
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

