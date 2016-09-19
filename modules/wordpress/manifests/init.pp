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

  #Backup plugins
  #Backup themes
  #Perfom a zip of the plugin
  #Try to backup to specified location
  #If a file already exists with the filename compare the hashes, if different then backup
  
  #How to get the list of plugin directories?
  #ls -1
  
  #Compress the directory:
  #tar -czf <plugin-dir-name>
  
  
}











