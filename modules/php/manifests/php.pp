Package{
  allow_virtual => false
}
  $local_install_path = "/etc/puppet/"
  $local_install_dir = "${local_install_path}installers/"

  class {"mysql":}
  class {"iptables": port => "80"}
  class {"httpd":}
  class {"php":}