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

$local_install_path = "/etc/puppet/"
$local_install_dir = "${local_install_path}installers/"
file {
  "${local_install_dir}":
    path       =>  "${local_install_dir}",
    ensure     =>  directory,
}

java { 'java-7':
  major_version => '7',
  update_version => '80',
  isDefault => true,
}
#java{ "java-7":
#    major_version => "6",
#    update_version => "34",
#    isDefault => true,
#}
->
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
