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

  $jenkins_short_ver     = "jenkins"

  $jenkins_group         = "${jenkins_short_ver}"
  $jenkins_user          = "${jenkins_short_ver}"

  $local_install_path = "/etc/puppet/"
  $local_install_dir  = "${local_install_path}installers/"
  $puppet_file_dir    = "modules/jenkins/"
  
  notify {
    "${module_name} installation completed":
  }  

  $java_major_version = "7"
  $java_update_version = "76"

#Ubuntu
#15.10 = wiley
#16.04 = Xenial
  if $::operatingsystem == 'CentOS' {
    notify {    "Using operating system:$::operatingsystem": }
  } elsif $::operatingsystem == "Ubuntu"{
    if $::operatingsystemmajrelease == "15.10" {

    }
  } else {
    notify {  "Operating system not supported:$::operatingsystem$::operatingsystemmajrelease":  }  
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
  
  #Requires java to be installed,
  #running the module again causes issues as the java module removes old versions before installing Java again which is a dependency of Jenkins and causes a failure
  java{"install-java":
    version => "${java_major_version}",
    updateVersion => "${java_update_version}",
  }
  
  $daemon = "daemon_0.6.4-1_amd64.deb"
  file {
    "${daemon}":
    require    =>  File["${local_install_dir}"],
    path       =>  "${local_install_dir}${daemon}",
    ensure     => present,
    source     =>  ["puppet:///${puppet_file_dir}${daemon}"]
  }
  
  package {
    "${daemon}":
    provider => "dpkg",
    source => "${local_install_dir}${daemon}",
    require => File["${daemon}"]
  }
  
  $jenkins = "jenkins_2.19.1_all.deb"
  file {
    "${jenkins}":
    require    =>  File["${local_install_dir}"],
    path       =>  "${local_install_dir}${jenkins}",
    ensure     => present,
    source     =>  ["puppet:///${puppet_file_dir}${jenkins}"]
  }
  
  package {
    "${jenkins}":
    provider => "dpkg",
    source => "${local_install_dir}${jenkins}",
    require => [File["${jenkins}"], Package["${daemon}"]]
  }

  #If there is an init.d script installed then you can use the service resource type.
  service {"jenkins":
    ensure => running,
    enable => true,
    require => Package["${jenkins}"]
  }

  #Install Jenkins
  #iptables port exemption needed?
  #/var/lib/jenkins/ contains all the configurations

  #Need to set a new password hash & last
  #jbcrypt:$2a$10$ hashed password

  #Adding the following to /var/lib/jenkins/config.xml will prevent you needing to add the initial password to the UI
  #Can use augeas to do this
#<jenkins.security.LastGrantedAuthoritiesProperty>
#<roles>
#<string>authenticated</string>
#</roles>
#<timestamp>1481300676660</timestamp>
#</jenkins.security.LastGrantedAuthoritiesProperty>

#  file {"/var/lib/jenkins/users/admin/config.xml":
#    mode => "a+w",
#    recurse => true,
#    require => Package["${jenkins}"]
#  }
#
#  $jenkins_changes=[
#    'set jenkins.security.LastGrantedAuthoritiesProperty/roles/string/#text authenticate',
#    'set jenkins.security.LastGrantedAuthoritiesProperty/timestamp/#text 1481300676660',
#  ]
#
#  augeas{ "configure-jekins-login":
#    incl => "/var/lib/jenkins/users/admin/config.xml",
#    lens => "Xml.lns",
#    context => "/files/var/lib/jenkins/users/admin/config.xml/user/properties/",
#    changes => $jenkins_changes,
#    require  => [File['/var/lib/jenkins/users/admin/config.xml']],
#    notify => Service["jenkins"]
#  }

}
