# Class: ufw
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

  if ("${operatingsystem}" == "CentOS"){
    if (versioncmp("${operatingsystemmajrelease}","7") == 0){
      $platform="-16.el7.x86_64.rpm"
    } elsif (versioncmp("${operatingsystemmajrelease}","6") == 0){
      $platform="-2.el6_6.x86_64.rpm"
    } else {
      #could use ${operatingsystemrelease} here but would make sensible ifs difficult want to use ${os['release']['minor']}
      fail("${operatingsystem} ${operatingsystemrelease} is unsupported")
    }
  } else {
    fail("${operatingsystem} is unsupported")
  }

  $unzip_file="unzip-${major_version}.${minor_version}${platform}"

  file {"${unzip_file}":
    ensure => present,
    path => "${local_install_dir}${unzip_file}",
    source => ["puppet:///${puppet_file_dir}${file_location}${unzip_file}"],
  }
  ->
  package {"unzip":
    ensure => present,
    provider => "rpm",
    source => "${local_install_dir}${unzip_file}",
    require => File["${unzip_file}"]
  }

}
