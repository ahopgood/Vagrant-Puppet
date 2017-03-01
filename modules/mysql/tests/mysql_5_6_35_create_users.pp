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
    minor_version => "6",
    patch_version => "35",
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
  ->
  mysql::create_user{"create user a":
    dbname => "a",
    rootusername => "root",
    rootpassword => "rootR00?s",
    dbpassword => "Secure1?",
    dbusername => "a",
  }
  ->
  mysql::create_user{"create user b":
    dbname => "b",
    rootusername => "root",
    rootpassword => "rootR00?s",
    dbpassword => "Secure1?",
    dbusername => "b",
  }


#verify access to the databases with root credentials
  #verify access to a particular database with user creds
  #verify access is blocked to second database with user creds