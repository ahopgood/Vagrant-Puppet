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

class tomcat (
  $tomcat_manager_username = '',
  $tomcat_manager_password = '',
  $tomcat_script_manager_username = '',
  $tomcat_script_manager_password = '',
  $logging_directory = undef,
  $major_version = "7",
  $minor_version = "54",
  $port = null,
  $java_opts = '',
  $catalina_opts = '' ) {


  #requires storeconfigs to be set in puppet master with a db adapter
#  Java<<| name == 'java-8' |>> -> Class['tomcat']
  #Java required
  if (versioncmp("${major_version}", 8) == 0){
    Java["java-7"] -> Class['tomcat']
    #manual check?
  } elsif (versioncmp("${major_version}", 7) == 0) {
    Java["java-6"] -> Class['tomcat']
  }

  #ls -l /var/log | grep tomcat
  #lrwxrwxrwx 1 root   root       25 Apr 11 08:00 tomcat8 -> /var/hosting/tomcat8/logs

  notify {
    "${module_name} installation completed":
  }  

  #global vars
  $puppet_file_dir      = "modules/${module_name}/"
  
  $tomcat_install_dir   = "/var/hosting/"
  $tomcat_full_ver      = "apache-tomcat-${major_version}.0.${minor_version}"
  $tomcat_tar           = "${tomcat_full_ver}.tar"
  $tomcat_file          = "${tomcat_tar}.gz"
  $tomcat_short_ver     = "tomcat${major_version}"
 
  $tomcat_service_file  = "${tomcat_short_ver}"
  $tomcat_group         = "${tomcat_short_ver}"
  $tomcat_user          = "${tomcat_short_ver}"
  $catalina_home        = "${tomcat_install_dir}${tomcat_short_ver}"
  $tomcat_users         = "${catalina_home}/conf/tomcat-users.xml"
  $tomcat_server_config = "${catalina_home}/conf/server.xml"
  $tomcat_env_file		  = "setenv.sh"

  if ("{$operatingsystem}" == "CentOS") {
    notify {    "Using operating system:$::operatingsystem": }
    $java_home            = "/usr/java/default"
  } elsif ("${operatingsystem}" == "Ubuntu"){
    notify {    "Using operating system:$::operatingsystem": }
    $java_home            = "/usr/lib/jvm/default"
  } else {
    notify {  "Operating system not supported:$::operatingsystem":  }  
  }

  group { "${tomcat_group}":
    ensure    =>  present,
#    gid       =>  1,
#    members   => ["tomcat"],
  }
  
  user { "${tomcat_user}":
    ensure      =>  present,
    home        =>  "/home/${tomcat_user}",
    managehome  =>  true,
    shell       =>  '/bin/bash',
    groups      =>  ["${tomcat_group}"],
    #password  =>  '$1$Gphy4jMa$WrTbubXCbIKjdaFHkcJX91'
    require     =>  Group["${tomcat_group}"]
  }

  #Create the directory we will install tomcat into.
  file {  [ "${tomcat_install_dir}"  ]:
    ensure    =>  directory,
    mode      =>  0777,
    owner     =>  "${tomcat_user}",
    group     =>  "${tomcat_group}",
    require   =>  User["${tomcat_user}"]
  }
  
  file { [ "${tomcat_file}" ]:
    path    =>  "${tomcat_install_dir}${tomcat_file}",
    ensure  =>  present,
    mode    =>  0777,
    owner   =>  "${tomcat_user}",      
    source  =>  ["puppet:///${puppet_file_dir}${tomcat_file}"],
#                    "${vagrant_share}${tomcat_file}"],
    require =>  File["${tomcat_install_dir}"],
  }

  exec {  "Unpack tomcat archive":
    path      =>  "/bin/",
    cwd       =>  "${tomcat_install_dir}",
    command   =>  "/bin/tar xfvz ${tomcat_install_dir}${tomcat_file}",
    user      =>  "${tomcat_user}",
    group     =>  "${tomcat_group}",
    require   =>  File[ "${tomcat_file}" ],
  }

  file {  "Create ${tomcat_short_ver} directory":
    path      =>  "${catalina_home}",
    ensure    =>  directory,
    mode	  =>  0777,
    owner     =>  "${tomcat_user}",
    group     =>  "${tomcat_group}",
    require   =>  Exec["Unpack tomcat archive"],
  }

  exec {  "Rename to ${tomcat_short_ver}":
    path      =>  "/bin/",
    cwd       =>  "${tomcat_install_dir}",
    command   =>  "cp -R ${tomcat_install_dir}${tomcat_full_ver}/* ${catalina_home}",
    user      =>  "${tomcat_user}",
    group     =>  "${tomcat_group}",
    #require   =>  Exec["Unpack tomcat archive"],
    require   =>  File["Create ${tomcat_short_ver} directory"],
  }

  exec {  "Set folder permissions":
    path      =>  "/bin/",
    command   =>  "chmod -R 755 ${catalina_home}",
    require   =>  Exec["Rename to ${tomcat_short_ver}"],
    notify	  =>  Service["${tomcat_service_file}"],
  }

  #Needs to be contextual to the OS
  file {  "Set JAVA_HOME":
    owner     =>  "${tomcat_user}",
    group     =>  "${tomcat_group}",
    path      =>  "/etc/profile.d/java.sh",
    content   =>  "export JAVA_HOME=/usr/java/default",
    require   =>  Exec["Unpack tomcat archive"],
  }

  file {  "Set CATALINA_HOME":
    owner     =>  "${tomcat_user}",
    group     =>  "${tomcat_group}",
    path      =>  "/etc/profile.d/catalina-home.sh",
    content   =>  "export CATALINA_HOME=${catalina_home}",
    require   =>  File["Set JAVA_HOME"],
  }
  
  #Link a specified folder to the tomcat/log folder
  #How to ensure the link can be created when the parent folder(s) doesn't exist.
  if ($logging_directory != undef){
    file { "${logging_directory}":
      ensure  =>  link,
      target  =>  "${$tomcat_install_dir}${tomcat_short_ver}/logs",
    }
  }

  file { "/usr/bin/${tomcat_short_ver}":
    ensure  =>  link,
    target  =>  "${$tomcat_install_dir}${tomcat_short_ver}/bin",
  }

  if ("${port}" != null){ 
    if ("${operatingsystem}"=="CentOS") {
      #Create an iptables (firewall) exception, persist and restart iptables 
      class { 'iptables':
        port => "${port}",
        require => File["Set CATALINA_HOME"]
      }
    } elsif ("${operatingsystem}"=="Ubuntu"){
      ufw {"test":
        port => '8080',
        isTCP => true
      }
    } else {
      fail("Operating system not supported:$::operatingsystem")  
    }

  }

  file {  "${tomcat_users}":
    content => template("${module_name}/tomcat-users.xml.erb"),
    require =>  File["Set CATALINA_HOME"],
    notify  =>  Service["${tomcat_service_file}"]
  }
  
  file { "${tomcat_server_config}":
    content => template("${module_name}/server.xml.${tomcat_short_ver}.erb"),
    require =>  File["Set CATALINA_HOME"],
    notify  =>  Service["${tomcat_service_file}"] 
  }
  
  if ("${java_opts}" == '') {
    $setenv_java_opts     = "" 
  } else {
    $setenv_java_opts     = "export JAVA_OPTS=\"${java_opts}\""
  }
  
  if ("${catalina_opts}" == '') {
    $setenv_catalina_opts = ""    
  } else {
    $setenv_catalina_opts = "export CATALINA_OPTS=\"${catalina_opts}\""
  }

  #Tomcat service startup script
  file {  [ "${tomcat_service_file}" ]:
    path    =>  "/etc/init.d/${tomcat_service_file}",
    content =>  template("${module_name}/${operatingsystem}/tomcat.sh.erb"),
    ensure  =>  present,
    mode    =>  0755,
    owner   =>  ["${tomcat_user}",'vagrant'],
    group   =>  ["${tomcat_group}"],      
    require =>  File["${tomcat_install_dir}"],
    notify  =>  Service["${tomcat_service_file}"],
  }
  
  file { ["${tomcat_env_file}"] :
  	path	=>	"${catalina_home}/bin/${tomcat_env_file}",
  	content	=>	template("${module_name}/${tomcat_env_file}.erb"),
	  ensure  =>  present,
    mode    =>  0755,
    owner   =>  ["${tomcat_user}",'vagrant'],
    group   =>  ["${tomcat_group}"],      
    require =>  File["${tomcat_install_dir}"],
    notify  =>  Service["${tomcat_service_file}"],
  }

  #set the service to start at boot, to verify you can run chkconfig --list tomcat
  service { ["${tomcat_service_file}"]:
    ensure  =>  running,
    enable  =>  true,
    provider => "init",
    require =>  [File["${tomcat_service_file}"],File["Set CATALINA_HOME"]]
  }  

  file { ["uninstall-tomcat-${major_version}-${minor_version}.sh"]:
	   path	=>	"${tomcat_install_dir}uninstall-tomcat-${major_version}-${minor_version}.sh",
	   ensure	=> 	present,
	   content => template("${module_name}/uninstall.sh.erb"),
     mode    =>  0755,
     owner   =>  ["${tomcat_user}",'vagrant'],
     group   =>  ["${tomcat_group}"],      	
  }

  #Create a user template x
  #Have the startup script initiated by either a user or a group with su permissions x
  #Set the ownership for the tomcat service to be the tomcat group? x
  #Set the ownership for the tomcat folder to be tomcat group x
  #Create a tomcat user variable x 
  #Pass in vm args into a setenv.sh file
  #Set the file permissions to be 755 throughout
  #Delete old files and folders if present
}

#include java
#include tomcat ('/etc/puppet/installers/')
#class { 'tomcat' :
#  local_install_dir => '/etc/puppet/installers/'
#}
#include tomcat::tomcat7



















