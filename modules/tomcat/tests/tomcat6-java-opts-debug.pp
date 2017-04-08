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

java { 'java-6':
  version => '6',
  update_version => '45'
}

class { 'tomcat':
	  tomcat_manager_username =>  'admin',
    tomcat_manager_password =>  'adminadmin',
#    logging_directory =>  '/var/log/tomcat6',
	  major_version => '6',
    minor_version => '44',
    port => '8080',
    java_opts => "-Xdebug -Xrunjdwp:transport=dt_socket,address=8000,server=y,suspend=n",
#    catalina_opts => "-Xms256"
}
