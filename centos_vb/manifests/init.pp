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
  file {
    '/etc/motd':
    ensure  =>  present,
    content => "Welcome to the development environment!",
  }
  
}
