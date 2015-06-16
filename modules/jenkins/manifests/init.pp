# Class: jenkins
#
# This module manages jenkins
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class jenkins (
  $major_version = "1",
  $minor_version = "614" ) {

  $jenkins_short_ver     = "jenkins${minor_version}"

  $jenkins_group         = "${jenkins_short_ver}"
  $jenkins_user          = "${jenkins_short_ver}"

  notify {
    "${module_name} installation completed":
  }  

  if $::operatingsystem == 'CentOS' {
    notify {    "Using operating system:$::operatingsystem": }
  } else {
    notify {  "Operating system not supported:$::operatingsystem":  }  
  }

   group { "${jenkins_group}":
    ensure    =>  present,
#    gid       =>  1,
#    members   => ["tomcat"],
  }
  
  user { "${jenkins_user}":
    ensure      =>  present,
    home        =>  "/home/${jenkins_user}",
    managehome  =>  true,
    shell       =>  '/bin/bash',
    groups      =>  ["${jenkins_group}"],
    require     =>  Group["${jenkins_group}"]
  }
  
  #Requires java to be installed
  class { 'java': 
    version => '7',
    updateVersion => '71',
  }
  
  #Install Jenkins
  #sudo rpm -ivh /vagrant/files/jenkins-1.614-1.1.noarch.rpm
  
  #iptables port exemption needed
  )
  
}
