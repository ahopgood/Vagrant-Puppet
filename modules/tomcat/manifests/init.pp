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

class tomcat ($tomcat_manager_password = "manager") {#($local_install_dir = '/etc/puppet/installers/') {
require java
  notify {
    "${name} installation completed":
  }
  
#  $vagrant_share      = "/installers/"
#  $local_install_path = "/etc/puppet/"
#  $local_install_dir  = "${local_install_path}installers/"
  $puppet_file_dir    = "modules/${name}/"
  
  $tomcat_install_dir   = "/var/hosting/"
  $tomcat_full_ver      = "apache-tomcat-7.0.54"
  $tomcat_short_ver     = "tomcat7"
  $tomcat_tar           = "${tomcat_full_ver}.tar"
  $tomcat_file          = "${tomcat_tar}.gz"
  $tomcat_users         = "${tomcat_install_dir}${tomcat_short_ver}/conf/tomcat-users.xml"
  $tomcat_service_file  = "tomcat"

  $catalina_home        ="${$tomcat_install_dir}${tomcat_short_ver}"

#  $tomcat_installer   = "unpack_tomcat.sh"
#  $tomcat_password    = "tomcat"
  
  user { 'tomcat':
    ensure      =>  present,
    home        =>  "/home/tomcat",
    managehome  =>  true,
    shell       =>  '/bin/bash',
    #password  =>  '$1$Gphy4jMa$WrTbubXCbIKjdaFHkcJX91'
  }

  #Create the directory we will install tomcat into.
  #"${tomcat_install_dir}"
  file {
    [ "${tomcat_install_dir}"  ]:
    ensure    =>  directory,
    mode      =>  0777,
    owner     =>  'tomcat',
    require   =>  User['tomcat']
  }
  
  #Create the directory that the local install files will be copied to from the puppet fileserver or vagrant shared folder 
  /*
  file {
    [ "${local_install_dir}" ]:
    ensure    =>  directory,
    mode      =>  0777,
    owner     =>  'tomcat',
    require   =>  User['tomcat']
  }
 */
  file {
    [ "${tomcat_file}" ]:
    path    =>  "${tomcat_install_dir}${tomcat_file}",
    ensure  =>  present,
    mode    =>  0777,
    owner   =>  ['tomcat','vagrant'],      
    source  =>  ["puppet:///${puppet_file_dir}${tomcat_file}"],
#                    "${vagrant_share}${tomcat_file}"],
    require =>  File["${tomcat_install_dir}"],
  } 
  
 /*
  exec {
    "Uncompress tomcat archive":
    path      =>  "/bin/",
    command   =>  "gzip -d ${local_install_dir}${$tomcat_file}",
    user      =>  "tomcat",
    require   => File["${tomcat_file}"],
  }
  */

  exec {
    "Unpack tomcat archive":
    path      =>  "/bin/",
#    path      =>  "${local_install_dir}",
    cwd       =>  "${tomcat_install_dir}",
    command   =>  "/bin/tar xfvz ${tomcat_install_dir}${tomcat_file}",
    user      =>  "tomcat",
    require   =>  File[ "${tomcat_file}" ],
  }

#Fails on rerun if move has already happened, need to make it 
  exec {
    "Rename to tomcat7":
    path      =>  "/bin/",
    cwd       =>  "${tomcat_install_dir}",
    command   =>  "cp -R ${tomcat_install_dir}${tomcat_full_ver} ${catalina_home}",
    user      =>  "tomcat",
    require   =>  Exec["Unpack tomcat archive"],
  }
  /*
  exec {
    "Copy to install directory":
    path      =>  "/bin/",
    command   =>  "cp -R ${local_install_dir}${tomcat_short_ver} ${tomcat_install_dir}",
    user      =>  "tomcat",
  }
  
  exec {
    "Copy to install directory":
    path      =>  "/bin/",
    command   =>  "mv ${local_install_dir}${tomcat_short_ver} ${tomcat_install_dir}",
    user      =>  "tomcat",
  }
  */

  exec {
    "Set folder permissions":
    path      =>  "/bin/",
    command   =>  "chmod -R 777 ${catalina_home}",
    require   =>  Exec["Rename to tomcat7"],
  }
   
  file {
    "Set JAVA_HOME":
    path      =>  "/etc/profile.d/java.sh",
    content   =>  "#!/bin/bash export JAVA_HOME=/usr/java/default",
    require   =>  Exec["Unpack tomcat archive"],
  }

  file {
    "Set CATALINA_HOME":
    path      =>  "/etc/profile.d/catalina-home.sh",
    content   =>  "export CATALINA_HOME=${catalina_home}",
    require   =>  File["Set JAVA_HOME"],
  }
/*  
  file  {
    "Logging Directory":
    path      =>  "${$tomcat_install_dir}${tomcat_short_ver}/logs",
    ensure    =>  directory,
    mode      =>  0644,
    owner     =>  'tomcat',
    recurse   =>   true,
    require   =>  File["Set CATALINA_HOME"],
  }
*/
  #If the service iptables is running then tomcat won't be accessible from a browser
  service {
    "iptables":
    enable  =>  false,
    ensure  => stopped,
    require => File["Set CATALINA_HOME"]
  }  
  
  file {
    "${tomcat_users}":
    content => template("${name}/tomcat-users.xml.erb"),
    require =>  File["Set CATALINA_HOME"]
  }

#Tomcat service startup script
  file {
    [ "${tomcat_service_file}" ]:
    path    =>  "/etc/init.d/${tomcat_service_file}",
    content =>  template("${name}/${tomcat_service_file}.erb"),
    ensure  =>  present,
    mode    =>  0777,
    owner   =>  ['tomcat','vagrant'],      
    require =>  File["${tomcat_install_dir}"],
  } 


  #set the service to start at boot, to verify you can run chkconfig --list tomcat
  service {
    ["${tomcat_service_file}"]:
    ensure  =>  running,
    enable  =>  true,
  }  

  #Create a user template?
  #Create a start up script
  #Set the startup script as a service
  #Delete old files and folders if present
  
}

#include java
#include tomcat ('/etc/puppet/installers/')
#class { 'tomcat' :
#  local_install_dir => '/etc/puppet/installers/'
#}
include tomcat
