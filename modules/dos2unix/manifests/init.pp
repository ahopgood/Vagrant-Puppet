class dos2unix{
  $local_install_path = "/etc/puppet/"
  $local_install_dir  = "${local_install_path}installers/"
  $puppet_file_dir    = "modules/dos2unix/"

  if (versioncmp("${operatingsystemmajrelease}", "18.04") == 0 ){
    $major_version = "7"
    $minor_version = "3"
    $patch_version = "4-3"
  } else {
    $major_version = "6"
    $minor_version = "0"
    $patch_version = "4-1"
  }
  $dos2unix_file = "dos2unix_${major_version}.${minor_version}.${patch_version}_${architecture}.deb"

  file {"${dos2unix_file}":
    ensure => present,
    path => "${local_install_dir}${dos2unix_file}",
    source => ["puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${dos2unix_file}"]
  }

  package {"dos2unix":
    provider => "dpkg",
    ensure => "installed",
    source => "${local_install_dir}${dos2unix_file}",
    require => File["${dos2unix_file}"]
  }
}