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

  if (versioncmp("${operatingsystem}", "CentOS") == 0){
    $provider = "rpm"
    if (versioncmp("${operatingsystemmajrelease}", "6") == 0){
      $patch_file = "patch-2.6-6.el6.x86_64.rpm"
    } elsif (versioncmp("${operatingsystemmajrelease}", "7") == 0){
      $patch_file = "patch-2.7.1-8.el7.x86_64.rpm"
    }
  } else {
    fail("${operatingsystem} is not currently supported by the patch module")
  }


  file{
    "${local_install_dir}${patch_file}":
    ensure => present,
    source => "puppet:///${puppet_file_dir}${patch_file}",
  }
  package {"patch":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${patch_file}",
    require => File["${local_install_dir}${patch_file}"],
    #1.12
  }
}
