$local_install_path = "/etc/puppet/"
$local_install_dir = "${local_install_path}installers/"

Package{
  allow_virtual => false,
}

$maven_major_version="3"
$maven_minor_version="5"
$maven_patch_version="2"

file{"${local_install_dir}":
  ensure => directory
}
->
java{"java-8":
  major_version => "8",
  update_version => "242",
  # isDefault => true,
}
->
class { 'maven':
  major_version => $maven_major_version,
  minor_version => $maven_minor_version,
  patch_version => $maven_patch_version,
}