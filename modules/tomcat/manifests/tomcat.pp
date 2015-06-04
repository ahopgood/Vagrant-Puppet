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
    minor_version => '62',
    port => '8080',
    #java_opts => "-Xms512m -Xmx1024m -XX:MaxPermSize=512m"
    #Notes
    # -Xss128k invalid stack thread stack size error when used and running service stop
    # -Xms12m invalid heap size when running service start
    # Java_Opts are causing issues with 
}
