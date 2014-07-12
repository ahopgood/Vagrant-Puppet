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
  $fileserver_module  = "fileserver/"
  $manifests          = "manifests/"

  #Create module folders for fileserver

  file {
    [ "${module_path}${fileserver_module}",
      "${module_path}${fileserver_module}${manifests}" ]:
    ensure    =>  directory,
    mode      =>  0664,
    owner     =>  'vagrant',    
  }

  #Install the setup_fileserver as a module
  exec {
    "Install setup_fileserver module":
    path      =>  "/bin/",
    command   =>  "mv /vagrant/fileserver.conf ${module_path}${fileserver_module}${manifests}"
  }
}

include centos_vb
