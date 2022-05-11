class nomad (
  $major_version = "1",
  $minor_version = "2",
  $patch_version = "6"
) {
  $local_install_path = "/etc/puppet/"
  $local_install_dir  = "${local_install_path}installers/"
  $puppet_file_dir    = "modules/nomad/"

  $nomad_file_name = "nomad_${major_version}.${minor_version}.${patch_version}_${architecture}.deb"

  $nomad_package_name = "nomad"
  file { "${nomad_file_name}":
    ensure => present,
    path   => "${local_install_dir}${nomad_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${nomad_file_name}",
  }
  package { "${nomad_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${nomad_file_name}",
    require  => [
      File["${nomad_file_name}"],
    ]
  }
}
