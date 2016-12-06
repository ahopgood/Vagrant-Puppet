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

  $java_major_version = "8"
  $java_update_version = "112"

#Ubuntu
#15.10 = wiley
#16.04 = Xenial
  if $::operatingsystem == 'CentOS' {
    notify {    "Using operating system:$::operatingsystem": }
  } elsif $::operatingsystem == "Ubuntu"{
    #create name of java deb file
    $java_name = "oracle-java${java_major_version}-jdk_${java_major_version}u${java_update_version}_amd64-${operatingsystem}_${::operatingsystemmajrelease}.deb"
    #Java deb format example oracle_java8-jdk_8u112_amd64-Ubuntu_15.10.deb
    if $::operatingsystemmajrelease == "15.10" {
      notify{"We're on Ubuntu wiley trying to use Java package ${java_name}":}
    }
    #install correct versions of dependencies for the ubuntu distro
    
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
  
  #Requires java to be installed
  java{"install-java":
    version => '7',
    updateVersion => '76',
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
  
  #Install Jenkins
  #iptables port exemption needed
  
}
