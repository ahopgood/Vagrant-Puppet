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

  $dbname = "test"
  $dbusername = "root"
  $dbpassword = "rootR00?s"

  class { "mysql":
    password => "rootR00?s",
    root_home => "/home/vagrant",
    major_version => "5",
    minor_version => "6",
    patch_version => "35",
  }
  ->
  mysql::create_database{
    "create_lanboard_database":
      dbname => "${dbname}",
      dbusername => "${dbusername}",
      dbpassword => "${dbpassword}",
  }
  ->
  mysql::differential_backup{
    "database_backup":
      dbname => "${dbname}",
      dbusername => "${dbusername}",
      dbpassword => "${dbpassword}",
      backup_path => "/home/vagrant/",
      hour => "*",
      minute => "*",
  }
  ->
  exec {"sleep":
    path => "/bin/",
    command => "ls -l /home/vagrant/*-${dbname}backup.sql",
    tries => 2,
    try_sleep => "60",
    #Inserted to allow for a backup to be taken before we attempt a restore
  }
  ->
  mysql::differential_restore{
    "database_restore":
      dbname => "${dbname}",
      dbusername => "${dbusername}",
      dbpassword => "${dbpassword}",
      backup_path => "/home/vagrant/",
  }
