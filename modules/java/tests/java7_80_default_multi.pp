Package{
  allow_virtual => false,
}
$local_install_path = "/etc/puppet/"
$local_install_dir = "${local_install_path}installers/"

file {
  "${local_install_dir}":
    path       =>  "${local_install_dir}",
    ensure     =>  directory,
}
java{"java-7":
  major_version => '7',
  update_version => '80',
  isDefault => true,
  multiTenancy => true,
}