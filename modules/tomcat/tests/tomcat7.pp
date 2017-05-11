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

java { 'java-7':
  version => '7',
  update_version => '71'
}

class { 'tomcat':
	  tomcat_manager_username =>  'admin',
    tomcat_manager_password =>  'adminadmin',
#    logging_directory =>  '/var/log/tomcat7',
	  major_version => '7',
    minor_version => '54',
    port => '8081',
    java_opts => "-Xms512m -Xmx1024m -XX:MaxPermSize=512m",
    #Notes
    # Java_Opts are causing issues with service shutdown
    # -Xss128k invalid stack thread stack size error when used and running service stop
    # -Xms12m invalid heap size when running service start
    catalina_opts => "-Xms512m -Xmx1024m -XX:MaxPermSize=512m",
    tomcat_script_manager_username => 'robomanager',
    tomcat_script_manager_password => 'robomanager',
}
