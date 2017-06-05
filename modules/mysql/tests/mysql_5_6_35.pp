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

  class { "mysql":
    password => "rootR00?s",
    root_home => "/home/vagrant",
    minor_version => "6",
    patch_version => "35",
  }