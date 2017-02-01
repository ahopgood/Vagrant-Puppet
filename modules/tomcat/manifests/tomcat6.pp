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

java{"java":
  version => '6',
  updateVersion => '45'
}

class { 'tomcat':
	  tomcat_manager_username =>  'admin',
    tomcat_manager_password =>  'adminadmin',
#    logging_directory =>  '/var/log/tomcat6',
	  major_version => '6',
    minor_version => '44',
    port => '8080',
#    java_opts => "-Xms128m",
#    catalina_opts => "-Xms256"
}
