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
  mysql::create_database{"Create db a":
    dbname => "a",
    dbpassword => "rootR00?s",
    dbusername => "root",
  }
  ->
  mysql::create_database{"Create db b":
    dbname => "b",
    dbpassword => "rootR00?s",
    dbusername => "root",
  }

  #verify access to the databases with root credentials