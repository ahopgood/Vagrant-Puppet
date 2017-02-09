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

class { 'java':
  version => '7',
  update_version => '71'
}

class { 'tomcat':
	tomcat_manager_username =>  'admin',
    tomcat_manager_password =>  'adminadmin',
#    logging_directory =>  '/var/log/tomcat8',
	major_version => '8',
    minor_version => '23',
    port => '8080',
#    java_opts => "-Xms128m",
    catalina_opts => "-Xms256m"
}
