# Class: patch
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
class patch {
  
  $local_install_path = "/etc/puppet/"
  $local_install_dir = "${local_install_path}installers/"
  $puppet_file_dir = "modules/${module_name}/"


  if (versioncmp("CentOS", "${operatingsystem}") == 0){
    $platform = ".${architecture}.rpm"  #architecture = x86_64
    $provider = "rpm"

    if (versioncmp("6", "${operatingsystemmajrelease}") == 0){
      $release = "-6.el${operatingsystemmajrelease}"
      $patch_file = "patch-2.6${release}${platform}"

    } elsif (versioncmp("7", "${operatingsystemmajrelease}") == 0){
      $release = "-8.el${operatingsystemmajrelease}"
      $patch_file = "patch-2.7.1${release}${platform}"

    } else {
      fail("${operatingsystem} version ${operatingsystemmajrelease} is not currently supported by the patch module")
    }
  } elsif (versioncmp("Ubuntu", "${operatingsystem}") == 0) {
    $platform = "${architecture}.deb" #architecture = amd64
    $provider = "dpkg"

    if (versioncmp ("15.10", "${operatingsystemmajrelease}") == 0) {
      $release = "-1_"
      $patch_file = "patch_2.7.5${release}${platform}"

    } elsif (versioncmp ("16.04", "${operatingsystemmajrelease}") == 0){
      #Note that patch 2.7.5 is already installed on Ubuntu 16.04 but this is here in case we want to add an update in future
      $release = "-1ubuntu0.${operatingsystemmajrelease}.2_"
      $patch_file = "patch_2.7.5${release}${platform}"
    } elsif (versioncmp ("18.04", "${operatingsystemmajrelease}") == 0){
      #Note that patch 2.7.6 is already installed on Ubuntu 18.04 but this is here in case we want to add an update in future
      $release = "-2ubuntu1.1_"
      $patch_file = "patch_2.7.6${release}${platform}"
    } else {
      fail("${operatingsystem} version ${operatingsystemmajrelease} is not currently supported by the patch module")
    }
  } else {
    fail("${operatingsystem} is not currently supported by the patch module")
  }


  file{
    "${local_install_dir}${patch_file}":
    ensure => present,
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${patch_file}",
  }
  package {"patch":
    ensure => present,
    provider => "${provider}",
    source => "${local_install_dir}${patch_file}",
    require => [
      File["${local_install_dir}${patch_file}"],
    ]
    #1.12
  }
}
