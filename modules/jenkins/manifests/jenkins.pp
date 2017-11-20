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
#HOw do we create the back up location?
file {["/vagrant/","/vagrant/backup/","/vagrant/backup/jenkins/"]:
  ensure => directory,
}

->
# class { 'jenkins': 
#   perform_manual_setup => true,
#   plugin_backup => "/vagrant/backup/jenkins/",
# }

class {'jenkins':
  perform_manual_setup => false,
  plugin_backup => "/vagrant/backup/test/",
}

