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

class { 'tomcat':
	tomcat_manager_username =>  'admin',
    tomcat_manager_password =>  'adminadmin',
    logging_directory =>  '/var/log/tomcat7',
	major_version => '7',
    minor_version => '44',
    port => '8080',
    java_opts => "-Xms128m"
}
