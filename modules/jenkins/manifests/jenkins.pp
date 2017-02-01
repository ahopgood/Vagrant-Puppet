# Class: jenkins
#
# This module manages jenkins
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#

Package{
  allow_virtual => false,
}
file {
  "/etc/puppet/installers/":
    ensure     =>  directory,
}
->
class { 'jenkins': }
-> jenkins::backup{"test-backup":
  backup_location => "/vagrant/backups/",
}


