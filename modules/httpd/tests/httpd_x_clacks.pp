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

  class { "iptables":
    port => "80",
  }
  
  class { "httpd": }
  ->
  httpd::xclacks{"x-clacks":}  
  class { "augeas": }