
$local_install_path = "/etc/puppet/"
$local_install_dir  = "${local_install_path}installers/"
file {
  "${local_install_dir}":
    ensure => directory,
}

class { "grype":
  major_version => "0",
  minor_version => "29",
  patch_version => "0"
}