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

  class { "httpd": }
  
  httpd::virtual_host{"test":
    server_name => "www.alexander.com",
  }