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

  #$::root_home = "/home/vagrant"
  class { "mysql":
    password => "rootR00?s",
    root_home => "/home/vagrant",
  }
  ->
  mysql::create_database{"Create db 1":
    dbname => "test",
    dbpassword => "rootR00?s",
    dbusername => "root",
  }