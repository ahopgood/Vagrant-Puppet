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
  
  #Change ownership to the apache user on the /var/www/html/wordpress 
    
  mysql::create_database{
    "create_wordpress_database":
    dbname => "${database_name}",
    dbusername => "root",
    dbpassword => "root",
  }
  
  mysql::create_user {
    "create_restricted_wordpress_db_user":
    dbname => "${database_name}",
    rootusername => "root",
    rootpassword => "root",
    dbusername => "${database_username}",
    dbpassword => "${database_password}",
  }

  mysql::differential_restore{
    "wordpress_database_restore":
    dbname => "${database_name}",
    dbusername => "${database_username}",
    dbpassword => "${database_username}",
    backup_path => "/vagrant/backups/",
  }
  
  mysql::differential_backup{
    "wordpress_database_backup":
    dbname => "${database_name}",
    dbusername => "${database_username}",
    dbpassword => "${database_username}",
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
