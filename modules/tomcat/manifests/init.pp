# Class: tomcat
#
# This module manages tomcat
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#

class tomcat {
}

#include java
#include tomcat ('/etc/puppet/installers/')
#class { 'tomcat' :
#  local_install_dir => '/etc/puppet/installers/'
#}
#include tomcat::tomcat7 ('admin','/var/log/tomcat7')

  class { 'tomcat::tomcat7':
    tomcat_manager_password => 'admin',
    logging_directory =>  '/var/tomcat7/logs',
  }  
