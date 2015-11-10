# Class: wordpress
#
# This module manages a wordpress installation
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
 
class {'mysql':}
  
class { 'wordpress':
  major_version => '4',
  minor_version => '3',
  patch_version => '1',
}