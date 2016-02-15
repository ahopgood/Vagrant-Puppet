Package{
  allow_virtual => false
}

  $local_install_path = "/etc/puppet/"
  $local_install_dir = "${local_install_path}installers/"

  #root dbusername
  #root dbpassword
  #dbname
  #restricted db username
  #restricted db password

  class {"iptables": port => "80"}
  class {"httpd":}
  class {"mysql":}
  class {"php":}
  
  $database_name = "wordpress"
  $database_username = "wordpress"
  $database_password = "wordpress"
  
class { 'wordpress':
  major_version => '4',
  minor_version => '3',
  patch_version => '1',
}