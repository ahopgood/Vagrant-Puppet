# Class: centos_vb
#
# This module manages a development centos_vb virtual machine
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class centos_vb {
  $module_path        = "/etc/puppet/modules/"
# $module_path        = "/home/vagrant/"
  $fileserver_module  = "fileserver/"
  $manifests          = "manifests/"

  #Create module folders for fileserver

  file {
    [ "${module_path}",
      "${module_path}${fileserver_module}",
      "${module_path}${fileserver_module}${manifests}" ]:
    ensure    =>  directory,
    mode      =>  0664,
    owner     =>  'vagrant',    
  }
 
  #Install the setup_fileserver as a module
  /** 
  file { 
    "${module_path}${fileserver_module}Modulefile":
    source  =>  "/vagrant/manifests/Modulefile",
    ensure  =>  present,
    require =>  File["${module_path}${fileserver_module}${manifests}"],
  }
 */
  /*
  exec {
    "Install setup_fileserver module":
    path      =>  "/bin/",
    command   =>  "cp /vagrant/manifests/fileserver.pp ${module_path}${fileserver_module}${manifests}/init.pp",
#puppet module folder doesn't provide write permissions?
#    command   => "cp /vagrant/manifests/setup_fileserver.pp .puppet/modules/fileserver/manifests/"
    require   =>  File["${module_path}${fileserver_module}Modulefile"],
  }
*/ 
/* 
  exec {
    "Copy modules": 
    path    =>  "/bin/",
    command =>  "cp -R /modules/* ${module_path}",  
  }
*/
}


#include module_copy
include centos_vb

#  include module_fileserver
include mysql