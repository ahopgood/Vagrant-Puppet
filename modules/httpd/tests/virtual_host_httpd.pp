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
  
  class { "augeas": }

  file {"/var/www/alexander/":
    ensure => directory,
  }
  ->
  file {"/var/www/alexander/index.html":
    ensure => present,
    content => "<html><title>Test Page</title><body><h1>Alex's test page</h1></body></html>"
  }
  ->
  httpd::virtual_host{"test":
    server_name => "www.alexander.com",
    document_root => "/var/www/alexander/",
  }