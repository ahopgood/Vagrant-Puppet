Package {
  allow_virtual => false
}

$local_install_path = "/etc/puppet/"
$local_install_dir = "${local_install_path}installers/"

file {
  "${local_install_dir}":
    path       =>  "${local_install_dir}",
    ensure     =>  directory,
}

mysql::connector::java{"connector java":
#  major_version => "1",
#  minor_version => "4",
#  patch_version => "0",
  destination_path => "/home/vagrant/",
}