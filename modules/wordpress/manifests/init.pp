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
  
  mysql::create_table{
    "create_wordpress_database":
    databasename => "wordpress",
    dbusername => "root",
    dbpassword => "root",
  }

/**
  mysql::differential_backup{
    "wordpress_database_backup":
    dbname => "wordpress",
    dbusername => "root",
    dbpassword => "root",
    backup_path => "/vagrant/backups",
    module_name => "${module_name}"
  }
 */
   
  #Install mysql
  #Setup wordpress database
  #Setup root user and password on mysql
  #
  #Unzipping of wordpres-4.3.1.tar.gz into html shared folder
  #Set firewall port in iptables
  #generate a wp-config.php with the database values inside
  #Backup 
}
