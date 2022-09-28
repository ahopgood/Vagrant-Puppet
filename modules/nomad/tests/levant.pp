$local_install_path = "/etc/puppet/"
$local_install_dir  = "${local_install_path}installers/"
file {
  "${local_install_dir}":
    ensure => directory,
}

nomad::levant{"install":}