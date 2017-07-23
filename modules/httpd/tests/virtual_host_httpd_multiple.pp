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
  httpd::virtual_host{"test-alexander":
    server_name => "www.alexander.com",
    document_root => "/var/www/alexander/",
    server_alias => ["alexander.com","alexander.net"]
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
  
  httpd::virtual_host{"test-katherine":
    server_name => "www.katherine.com",
    document_root => "/var/www/katherine/",
    server_alias => ["katherine.com"]
  }
  ->
  file {"/var/www/katherine/":
    ensure => directory,
    #    require => Class["httpd"]
  }
  ->
  file {"/var/www/katherine/index.html":
    ensure => present,
    content => "<html><title>Test Page</title><body><h1>Alex's test page</h1></body></html>"
  }
