# Class: wordpress
#
# This module manages wordpress
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class wordpress (
  $major_version = '4',
  $minor_version = '3',
  $patch_version = '1'
) {

  $local_install_path = "/etc/puppet/"
  $local_install_dir = "${local_install_path}installers/"
  $puppet_file_dir = "modules/${module_name}/"

  Class["php"]
  ->
  Class["wordpress"]
  
  $wordpress = "wordpress-${major_version}.${minor_version}.${patch_version}"
  $wordpress_file_tar = "${wordpress}.tar"
  $wordpress_file_gzip = "${wordpress_file_tar}.gz"
  
  #Unpack the WordPress tar.gz to the apache /var/www/html folder within its own wordpress folder.
  file{"${local_install_dir}${wordpress_file_gzip}":
    ensure => present,
    source => "puppet:///${puppet_file_dir}${wordpress_file_gzip}",
  }

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }
  
  exec{"gunzip":
     command => "gunzip -rdc ${local_install_dir}${wordpress_file_gzip} > /var/www/html/${wordpress_file_tar}",
     cwd => "/bin/",
  }

  exec{"untar":
     command => "tar -xf /var/www/html/${wordpress_file_tar}",
     cwd => "/var/www/html/",
  }
   
  exec{"remove_tar":
    command => "rm /var/www/html/${wordpress_file_tar}",
  }
  
  #A look up for the apache::user value should be used
  exec{"chown":
    command => "chown apache:apache -R /var/www/html/wordpress",
    require => Exec["untar"]
  }
  
  #Wordpress is trying to load pages from 192.168.33.21 instead of 192.168.33.22 
    
  mysql::create_database{
    "create_wordpress_database":
    dbname => "${database_name}",
    dbusername => "${root_database_username}",
    dbpassword => "${root_database_password}",
  }
  
  mysql::create_user {
    "create_restricted_wordpress_db_user":
    dbname => "${database_name}",
    rootusername => "${root_database_username}",
    rootpassword => "${root_database_password}",
    dbusername => "${database_username}",
    dbpassword => "${database_password}",
  }

  mysql::differential_restore{
    "wordpress_database_restore":
    dbname => "${database_name}",
    dbusername => "${database_username}",
    dbpassword => "${database_password}",
    backup_path => "/vagrant/backups/",
  }
  
  mysql::differential_backup{
    "wordpress_database_backup":
    dbname => "${database_name}",
    dbusername => "${database_username}",
    dbpassword => "${database_password}",
    backup_path => "/vagrant/backups/",
    minute => "*/2"
  } 
  #Install mysql
  #Setup wordpress database
  #Setup root user and password on mysql
  #
  #Unzipping of wordpres-4.3.1.tar.gz into html shared folder
  #Set firewall port in iptables
  #generate a wp-config.php with the database values inside
  #Backup 
  #<%= @dbname %> wordpress
  #<%= @dbusername %> wordpress
  #<%= @dbpassword %> wordpress
  #<%= @dbhost %> localhost
  #<%= @tableprefix %> wp_
  $database_name = "wordpress"
  $tableprefix = "wp_"
  $database_host = "localhost"

  file{"wp-config.php":
    path => "/var/www/html/wordpress/wp-config.php",
    ensure => present,
    owner => "apache",
    group => "apache",
    mode => 777,
    content => template("${module_name}/wp-config.php.erb"),
  }  
}

define wordpress::backup_core{
    #This file should be present for plugin and theme backup, how to share this?
  file {"backup-directory.sh":
    path => "/usr/local/bin/backup-directory.sh",
    ensure => present,
    owner => "apache",
    group => "apache",
    mode => 777,
#    content => template("${module_name}/backup-directory.sh.erb"),
    source => ["puppet:///modules/${module_name}/backup-directory.sh"],
  }
}

define wordpress::plugin_backup(
  $plugin_dir = undef,
  $backup_path = undef,
  $hour = "*",
  $minute = "*"
){

  if ($plugin_dir == undef) {
    fail("You must define a plugin directory path location in order to perform backup of the wordpress plugins")
  }
  if ($backup_path == undef) {
    fail("You must define a backup path location in order to do a backup of the wordpress plugins")
  }
  
#  Define["wordpress::backup_core"] -> Define["wordpress::plugin_backup{}"]
  
#  Wordpress::backup_core["backup"] -> Wordpress::plugin_backup["this"]
  
#  wordpress::backup_core{"backup":}

  file {"${backup_path}":
    path => "${backup_path}",
    ensure => directory,
  }

  file{"backup-plugins.sh":
    path => "/usr/local/bin/backup-plugins.sh",
    ensure => present,
    owner => "apache",
    group => "apache",
    mode => 777,
    content => template("${module_name}/backup-plugins.sh.erb"),
    require => Wordpress::Backup_core["backup-core"]
  }
  
  cron { "backup-plugins-cron":
    command => "/usr/local/bin/backup-plugins.sh",
    user => vagrant,
    hour => "${hour}",
    minute => "${minute}",
    require => File["backup-plugins.sh"]
  }
}

define wordpress::theme_backup(
  $theme_dir = undef,
  $backup_path = undef,
  $hour = "*",
  $minute = "*"
){

  if ($theme_dir == undef
  ) {
    fail("You must define a theme directory path location in order to perform backup of the wordpress themes.")
  }
  if ($backup_path == undef) {
    fail("You must define a backup path location in order to do a backup of the wordpress themes.")
  }
  
  file {"${backup_path}":
    path => "${backup_path}",
    ensure => directory,
  }
  
  file{"backup-themes.sh":
    path => "/usr/local/bin/backup-themes.sh",
    ensure => present,
    owner => "apache",
    group => "apache",
    mode => 777,
    content => template("${module_name}/backup-themes.sh.erb"),
    require => Wordpress::Backup_core["backup-core"]
  }
  
  cron { "backup-themes-cron":
    command => "/usr/local/bin/backup-themes.sh",
    user => vagrant,
    hour => "${hour}",
    minute => "${minute}",
    require => File["backup-themes.sh"]
  }
}

define wordpress::restore_core{
  file {"restore-directory.sh":
    path => "/usr/local/bin/restore-directory.sh",
    ensure => present,
    owner => "apache",
    group => "apache",
    mode => 777,
    source => ["puppet:///modules/${module_name}/restore-directory.sh"],
  }
}

define wordpress::plugin_restore(
  $plugin_dir = undef,
  $backup_path = undef,
){

  if ($plugin_dir == undef) {
    fail("You must define a plugin directory path location to restore the wordpress plugins to.")
  }
  if ($backup_path == undef) {
    fail("You must define a backup path location from which to do a restore of the wordpress plugins.")
  }

  file {"${backup_path}":
    path => "${backup_path}",
    ensure => directory,
  }

  file {"restore-plugins.sh":
    path => "/usr/local/bin/restore-plugins.sh",
    ensure => present,
    owner => "apache",
    group => "apache",
    mode => 777,
    content => template("${module_name}/restore-plugins.sh.erb"),
    require => Wordpress::Backup_core["restore-core"]
  }
  
  exec {"restore-plugins-cron":
    command => "/usr/local/bin/restore-plugins.sh",
    user => vagrant,
    require => File["restore-plugins.sh"]
  }
}

define wordpress::theme_restore(
  $theme_dir = undef,
  $backup_path = undef,
){

  if ($theme_dir == undef
  ) {
    fail("You must define a theme directory path location to restore the wordpress themes to.")
  }
  if ($backup_path == undef) {
    fail("You must define a backup path location in order to do a restore of the wordpress themes.")
  }
  
  file {"${backup_path}":
    path => "${backup_path}",
    ensure => directory,
  }
  
  file{"restore-themes.sh":
    path => "/usr/local/bin/restore-themes.sh",
    ensure => present,
    owner => "apache",
    group => "apache",
    mode => 777,
    content => template("${module_name}/restore-themes.sh.erb"),
    require => Wordpress::Restore_core["restore-core"]
  }
  
  exec { "restore-themes-cron":
    command => "/usr/local/bin/restore-themes.sh",
    user => vagrant,
    require => File["restore-themes.sh"]
  }
}





