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
  class {"httpd":}
  ->
  class {"iptables": port => "80"}
  ->
  class {"mysql":}
  ->
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
