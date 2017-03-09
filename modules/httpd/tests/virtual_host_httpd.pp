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
#  class { "augeas": }
  class { "iptables":
    port => "80",
  }
  
  class { "httpd": }

  httpd::virtual_host{"test":
    server_name => "www.alexander.com",
    document_root => "/var/www/alexander/",
  }
  ->
  file {"/var/www/alexander/":
    ensure => directory,
    #    require => Class["httpd"]
  }
  ->
  file {"/var/www/alexander/index.html":
    ensure => present,
    content => "<html><title>Test Page</title><body><h1>Alex's test page</h1></body></html>"
  }
