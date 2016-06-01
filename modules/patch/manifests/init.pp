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
  
  $patch_file = "patch-2.6-6.el6.x86_64.rpm"
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
