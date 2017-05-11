# Class: unzip
#
# This module manages unzip
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class unzip (
  $major_version = "6",
  $minor_version = "0",
) {
  $puppet_file_dir      = "modules/unzip/"
  $file_location        = "${operatingsystem}/${operatingsystemmajrelease}/"

  $local_install_path = "/etc/puppet/"
  $local_install_dir = "${local_install_path}installers/"

  if ("${operatingsystem}" == "CentOS"){
    $provider = "rpm"
    if (versioncmp("${operatingsystemmajrelease}","7") == 0){
      $platform="-16.el7.x86_64.rpm"
    } elsif (versioncmp("${operatingsystemmajrelease}","6") == 0){
      $platform="-2.el6_6.x86_64.rpm"
    } else {
      #could use ${operatingsystemrelease} here but would make sensible ifs difficult want to use ${os['release']['minor']}
      fail("${operatingsystem} ${operatingsystemrelease} is unsupported")
    }
    $unzip_file="unzip-${major_version}.${minor_version}${platform}"
  } elsif ("${operatingsystem}" == "Ubuntu") {
    $provider = "dpkg"
    if (versioncmp("${operatingsystemmajrelease}","15.10") == 0){
      $platform="-17ubuntu1.2_amd64.deb"
    } else {
      #could use ${operatingsystemrelease} here but would make sensible ifs difficult want to use ${os['release']['minor']}
      fail("${operatingsystem} ${operatingsystemrelease} is unsupported")
    }
    $unzip_file="unzip_${major_version}.${minor_version}${platform}"
  } else {
    fail("${operatingsystem} is unsupported")
  }

  file {"${unzip_file}":
    ensure => present,
    path => "${local_install_dir}${unzip_file}",
    source => ["puppet:///${puppet_file_dir}${file_location}${unzip_file}"],
  }
  ->
  package {"unzip":
    ensure => present,
    provider => "${provider}",
    source => "${local_install_dir}${unzip_file}",
    require => File["${unzip_file}"]
  }

}
