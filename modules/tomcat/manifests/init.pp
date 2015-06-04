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
  $tomcat_manager_username = "manager",
  $tomcat_manager_password = "manager", 
  $logging_directory = "/var/log/tomcat",
  $major_version = "7",
  $minor_version = "54",
  $port = null,
  $java_opts = "",
  $catalina_opts = "" ) {

require java
  notify {
    "${module_name} installation completed":
  }
  

  $puppet_file_dir      = "modules/${module_name}/"
  
  $tomcat_install_dir   = "/var/hosting/"
  $tomcat_full_ver      = "apache-tomcat-${major_version}.0.${minor_version}"
  $tomcat_tar           = "${tomcat_full_ver}.tar"
  $tomcat_file          = "${tomcat_tar}.gz"
  $tomcat_short_ver     = "tomcat7"
 
  $tomcat_service_file  = "${tomcat_short_ver}"
  $tomcat_group         = "${tomcat_short_ver}"
  $tomcat_user          = "${tomcat_short_ver}"
  $catalina_home        = "${tomcat_install_dir}${tomcat_short_ver}"
  $tomcat_users         = "${catalina_home}/conf/tomcat-users.xml"
  $tomcat_env_file		= "setenv.sh" 
  
  if $::operatingsystem == 'CentOS' {
    notify {    "Using operating system:$::operatingsystem": }
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

#Fails on rerun if move has already happened, need to make it 
  exec {  "Rename to tomcat7":
    path      =>  "/bin/",
    cwd       =>  "${tomcat_install_dir}",
    command   =>  "cp -R ${tomcat_install_dir}${tomcat_full_ver} ${catalina_home}",
    user      =>  "${tomcat_user}",
    group     =>  "${tomcat_group}",
    require   =>  Exec["Unpack tomcat archive"],
  }

  exec {  "Set folder permissions":
    path      =>  "/bin/",
    command   =>  "chmod -R 755 ${catalina_home}",
    require   =>  Exec["Rename to tomcat7"],
  }
   
  file {  "Set JAVA_HOME":
    owner     =>  "${tomcat_user}",
    group     =>  "${tomcat_group}",
    path      =>  "/etc/profile.d/java.sh",
    content   =>  "#!/bin/bash export JAVA_HOME=/usr/java/default",
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
  file { $logging_directory:
    ensure  =>  link,
    target  =>  "${$tomcat_install_dir}${tomcat_short_ver}/logs",
  }
  
  if ("${port}" != null){ 
  	#Create an iptables (firewall) exception, persist and restart iptables 
	service { "iptables":
    	enable  =>  true,
    	ensure  => running,
    	require => File["Set CATALINA_HOME"]
  	}  
 
  	exec { "tomcat-port":
    	path		=>  "/sbin/",
    	command		=>  "iptables -I INPUT 1 -m state --state NEW -p tcp --dport ${port} -j ACCEPT",
  	}
  
  	exec { "save-ports":
  		path		=>	"/sbin/",
  		command		=> "service iptables save",
  		notify   	=>  Service["iptables"],
  		require		=> Exec["tomcat-port"]
  	}
  }

  file {  "${tomcat_users}":
    content => template("${module_name}/tomcat-users.xml.erb"),
    require =>  File["Set CATALINA_HOME"],
    notify  =>  Service["${tomcat_service_file}"]
  }

  #Tomcat service startup script
  file {  [ "${tomcat_service_file}" ]:
    path    =>  "/etc/init.d/${tomcat_service_file}",
    content =>  template("${module_name}/${tomcat_service_file}.erb"),
    ensure  =>  present,
    mode    =>  0755,
    owner   =>  ["${tomcat_user}",'vagrant'],
    group   =>  ["${tomcat_group}"],      
    require =>  File["${tomcat_install_dir}"],
    notify  =>  Service["${tomcat_service_file}"],
  }

#if (  "${java_opts}" != "" && "${catalina_opts}" !="" ){  
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
#}
  #set the service to start at boot, to verify you can run chkconfig --list tomcat
  service { ["${tomcat_service_file}"]:
    ensure  =>  running,
    enable  =>  true,
    require =>  [File["${tomcat_service_file}"],File["Set CATALINA_HOME"]]
  }  

  #Create a user template x
  #Create a start up script x
  #Set the startup script as a service x
  #Have the startup script initiated by either a user or a group with su permissions x
  #Set the ownership for the tomcat service to be the tomcat group? x
  #Set the ownership for the tomcat folder to be tomcat group x
  #Set the logging directory as a symbolic link, ensure the directory exists first
  #Create a tomcat user variable x 
  #Add a manager username parameter x
  #Add a script-manager username and password
  #Default to no users if the username or password values are null/empty
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



















