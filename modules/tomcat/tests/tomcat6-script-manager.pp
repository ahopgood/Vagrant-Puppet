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
    tomcat_script_manager_username => 'robomanager',
    tomcat_script_manager_username => 'robomanager',
	  major_version => '6',
    minor_version => '44',
    port => '8080',
#    java_opts => "-Xms128m",
#    catalina_opts => "-Xms256"
}
