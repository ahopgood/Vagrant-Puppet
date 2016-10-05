Package{
  allow_virtual => false
}

  $local_install_path = "/etc/puppet/"
  $local_install_dir = "${local_install_path}installers/"

  file {
    "${local_install_dir}":
    path       =>  "${local_install_dir}",
    ensure     =>  directory,
  } 

  #root dbusername
  #root dbpassword
  #dbname
  #restricted db username
  #restricted db password

  class {"iptables": port => "80"}
  class {"httpd":}
  class {"mysql":}
  class {"php":
    major_version => '5',
    minor_version => '4',
    patch_version => '16',
  }
  
  #Used in the database differential backup and restore
  $database_name = "wordpress"
  $database_username = "wordpress"
  $database_password = "wordpresS1!"
  
  $root_database_username = "root"
  $root_database_password = "rootR00?s"
  $root_home = "/home/vagrant"
  
  class { 'wordpress':
    major_version => '4',
    minor_version => '3',
    patch_version => '1',
  }
  
  wordpress::backup_core{"backup-core":}
  $minute = "0"
  
  $plugin_backup_path = "/vagrant/backups/plugins/"
  
  $theme_backup_path = "/vagrant/backups/themes/"
      
  file {["/vagrant/backups/","${plugin_backup_path}","${theme_backup_path}"]:
    ensure => directory,
  }
  
  wordpress::plugin_backup{"plugin-backup":
    plugin_dir => "/var/www/html/wordpress/wp-content/plugins/",
    backup_path => "${plugin_backup_path}",
    minute => $minute,
  }
  
  wordpress::theme_backup{"theme-backup":
    theme_dir => "/var/www/html/wordpress/wp-content/themes/",
    backup_path => "${theme_backup_path}",
    minute => $minute,
  }
  
  wordpress::restore_core{"restore-core":}
  
  Class["wordpress"]
  ->  
  wordpress::plugin_restore{"plugin-restore":
    plugin_dir => "/var/www/html/wordpress/wp-content/plugins/",
    backup_path => "${plugin_backup_path}",
  }
  
#  wordpress::theme_restore{"theme-restore":
#    theme_dir => "/var/www/html/wordpress/wp-content/themes/",
#    backup_path => "${theme_backup_path}",
#  }