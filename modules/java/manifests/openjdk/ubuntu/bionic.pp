define  java::openjdk::ubuntu::bionic(
  $multiTenancy = undef,
  $major_version = undef,
  $update_version = undef,
) {
  #sudo puppet apply /vagrant/tests/openjdk.pp --modulepath=/etc/puppet/modules/
  $local_install_path = "/etc/puppet/"
  $local_install_dir  = "${local_install_path}installers/"
  $puppet_file_dir    = "modules/java/"

  notify{"Within BIONIC!":}
}