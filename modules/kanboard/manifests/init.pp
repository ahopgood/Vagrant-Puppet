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
  
  $dbtype = "mysql"
  $dbusername = "root"
  $dbpassword = "root"
  $dbname = "kanboard" 

  $local_install_path = "/etc/puppet/"
  $local_install_dir = "${local_install_path}installers/"
  #$puppet_file_dir = "modules/kanboard/"
  $puppet_file_dir = "modules/${module_name}/"
   
  notify {
    "${module_name} installation completed":
  }  


  Class["mysql"] 
  -> 
  Class["httpd"]
  #Class["kanboard"]
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
    require => [File["${local_install_dir}${php_gd_file}"], Package["php-common"], Package["freetype"], Package["libXpm"]],
    #2.0.34
  }
  file{
    "${local_install_dir}${php_mysql_file}":
    ensure => present,
    source => "puppet:///${puppet_file_dir}${php_mysql_file}",
  }
  package {"php-mysql":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${php_mysql_file}",
    require => [File["${local_install_dir}${php_mysql_file}"], Class["mysql"], Package["php-pdo"]],
    #5.1.73
  }

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
/*
  file{"install.sh":
    ensure => present,
    path => "/usr/local/bin/${dbname}-install.sh",
    source => ["puppet:///${puppet_file_dir}install.sh"],
  }
*/
  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

  $kanboard_file = "kanboard-1-0-19.zip"

  file{
    "${kanboard_file}":
    require => Package["httpd"],
    ensure => present,
    path => "/var/www/html/${kanboard_file}",
    source => ["puppet:///${puppet_file_dir}${kanboard_file}"],
  }

  exec{
    "unzip":
    require => [Class["mysql"],Package["httpd"],Package["unzip"],File["${kanboard_file}"]],
    command => "unzip -u /var/www/html/${kanboard_file}",
    cwd => "/var/www/html",
  }
  
  exec{
    "chown":
    require => Exec["unzip"],
    command => "chown -R apache:apache kanboard/data",
    cwd => "/var/www/html",
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
      
  #Need to add date and time to the backup scripts.
  #Need to have the script run on a cron tab
  #/usr/bin/crontab
  # DATE=$(date +"%d-%m-%Y-%H-%M")
  #$(date +"%Y-%m-%d-%H-%M").sql
  
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
  
  file{"config.php":
    require => Exec["chown"],
    path => "/var/www/html/kanboard/config.php",
    content => template("${module_name}/config.default.php.erb"),
    ensure => present,
    mode => 0755,
    owner => "apache",
    group => "apache",
    notify => Service["httpd"]
  }
    
  notify {
    "Kanboard":
  }
}