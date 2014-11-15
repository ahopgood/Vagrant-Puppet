# Class: module_fileserver
#
# This module manages module_fileserver
# This sets the paths specified in the fileserver.conf to allow puppet's fileserver syntax to be used:
# e.g. 
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class module_fileserver {
  $module_path        = "modules/"
  $fileserver_module  = "module_fileserver/"
  $manifests          = "manifests/"
  
#Setup the fileserver config so we can serve files via the puppet fileserver
  file {
    '/etc/puppet/fileserver.conf':
    ensure      =>  present,
    source      => 'puppet:///${fileserver_module}files/fileserver.conf',
  }

  #Ensure the destination directory for the installers is present
  file {
    '/etc/puppet/installers/':
    ensure      =>  directory,
    mode        =>  0666,
#    owner       =>  'installer',
  }
}
#include module_fileserver
