class grype {
  $local_install_path = "/etc/puppet/"
  $local_install_dir  = "${local_install_path}installers/"
  $puppet_file_dir    = "modules/grype/"

  $major_version = "0"
  $minor_version = "31"
  $patch_version = "1"

  $grype_file = "grype_${major_version}.${minor_version}.${patch_version}_linux_${architecture}.deb"

  file {"${grype_file}":
    ensure => present,
    path => "${local_install_dir}${grype_file}",
    source => ["puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${grype_file}"]
  }

  package {"grype":
    provider => "dpkg",
    ensure => "installed",
    source => "${local_install_dir}${grype_file}",
    require => File["${grype_file}"]
  }
}