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

$virtual_host_name = "www.alexander.com"
class { "httpd": }

class {"httpd::virtual_host::sites":}

httpd::virtual_host{"test":
  server_name => "www.alexander.com",
  document_root => "/var/www/alexander/",
  server_alias => ["alexander.com","alexander.net"]
}
->
file {"/var/www/alexander/":
  ensure => directory,
}
->
file {"/var/www/alexander/index.html":
  ensure => present,
  content => "<html><title>Test Page</title><body><h1>Alex's test page</h1></body></html>"
}
->
httpd::proxy::gateway::install{"install-gateway-module":}
->
httpd::proxy::gateway::set_virtual{"set virtual host gateway":
  virtual_host => $virtual_host_name,
}