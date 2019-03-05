Package{
  allow_virtual => false
}
# sudo puppet apply --parser=future /vagrant/tests/httpd.pp

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

  class { "httpd": }