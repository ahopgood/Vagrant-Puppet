# Class: python
#
# This module manages patch
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class python3 {
  
  $local_install_path = "/etc/puppet/"
  $local_install_dir = "${local_install_path}installers/"
  $puppet_file_dir = "modules/${module_name}/"


  if (versioncmp("Ubuntu", "${operatingsystem}") == 0) {
    if (versioncmp ("18.04", "${operatingsystemmajrelease}") == 0){
      @python3::ubuntu::bionic{"virtual":}
    } else {
      fail("${operatingsystem} version ${operatingsystemmajrelease} is not currently supported by the patch module")
    }
  } else {
    fail("${operatingsystem} is not currently supported by the patch module")
  }
}

define python3::ubuntu::bionic {
  $puppet_file_dir=$python3::puppet_file_dir
  $local_install_dir=$python3::local_install_dir

  $python3_file_name = "python3_3.6.7-1~18.04_amd64.deb"
  file { "${python3_file_name}":
    ensure => present,
    path   => "${local_install_dir}${python3_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${python3_file_name}",
  }
  package { "python3":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${python3_file_name}",
    require  => [
      File["${python3_file_name}"],
    ]
  }

}