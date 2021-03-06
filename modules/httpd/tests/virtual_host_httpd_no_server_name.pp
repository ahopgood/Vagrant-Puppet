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
  if (versioncmp("${operatingsystem}","Ubuntu") == 0) {
    ufw::service{"ufw-service":}
  }
  class {"httpd::virtual_host::sites":}
  class { "httpd": }

  httpd::virtual_host{"test":
    document_root => "/var/www/alexander/",
  }