Package{
  allow_virtual => false
}

  if (versioncmp("${operatingsystem}","Ubuntu") == 0) {
    ufw::service{"ufw-service":}
  }

  $local_install_path = "/etc/puppet/"
  $local_install_dir = "${local_install_path}installers/"

  file {
    "${local_install_dir}":
    path       =>  "${local_install_dir}",
    ensure     =>  directory,
  } 

  class { "httpd": } 
  class {"httpd::virtual_host::sites":}  
  httpd::virtual_host{"test":
    server_name => "www.alexander.com",
  }