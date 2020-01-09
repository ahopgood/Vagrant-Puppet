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
ufw::service{"ufw-service":}
class {"certbot":}
->
class { "httpd": }
->
Certbot::Apache{"bionic":}
class {"httpd::virtual_host::sites":}

file {["/var/www/", "/var/www/alexander/", "/var/www/alexander/test/"]:
  ensure => directory,
}
->
file{"/var/www/alexander/test/index.html":
  ensure => present,
  content => "<html><head></head><body><h1>A test homepage</h1><p>This is a placeholder for testing.</p></body></html>",
}
->
httpd::virtual_host{"test.alexanderhopgood.com":
  server_name   => "test.alexanderhopgood.com",
  document_root => "/var/www/alexander/test/",
  access_logs => true,
  error_logs => true
}
->
Certbot::Apache::Reinstall{"test":
  server_name   => "test.alexanderhopgood.com",
  server_aliases => ["www.test.alexanderhopgood.com","test.alexanderhopgood.co.uk", "www.test.alexanderhopgood.co.uk"],
  document_root => "/var/www/alexander/test/",
}