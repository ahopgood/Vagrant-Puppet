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
  
  notify {"${module_name} installation completed":}

  $java_major_version = "7"
  $java_update_version = "76"

#Ubuntu
#15.10 = wiley
#16.04 = Xenial
  if ($::operatingsystem) == 'CentOS' {
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
  $daemon = "daemon_0.6.4-1_amd64.deb"
  java{"install-java":
    version => "${java_major_version}",
    updateVersion => "${java_update_version}",
  }
  ->
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
    ensure => installed,
    source => "${local_install_dir}${jenkins}",
    require => [File["${jenkins}"], Package["${daemon}"]]
  }

  #If there is an init.d script installed then you can use the service resource type.
  service {"jenkins":
    ensure => stopped,
    enable => true,
    require => Package["${jenkins}"]
  }

  #Install Jenkins
  #iptables port exemption needed?
  #192.168.33.16:8080 to access the Jenkins admin page
  #/var/lib/jenkins/ contains all the configurations

  #Backup
  #rsync /var/lib/jenkins /vagrant/backup/2/ --exclude /var/lib/jenkins/plugins/
  #Get a list of the plugins from the jenkins API
  #http://192.168.33.16:8080/pluginManager/api/json?tree=plugins[shortName,version]&pretty=true

  #Restore & set ownership
  #$(date +%y-%m-%d-%h%M-jenkins-backup)
  #rsync/vagrant/backup/2/ /var/lib/jenkins
  #chown -R /var/lib/jenkins jenkins
  #chngrp -R /var/lib/jenkins jenkins
  #
}


/**
 *
 * Param $hour
 */

# Define: jenkins::backup
#
# A resource for a cron job to back up the /var/lib/jenkins/ directory using rsync.
# The plugins directory is excluded due to its size.
#
# A dated directory is created in the backup_location
#
# Parameters:
# * $backup_location - A directory path to the main backup location
# * $hour - the hour value for the cron task, defaults to * (i.e. every hour)
# * $minute - the minute value for the cron task, defaults to 0 (so at the beginning of every hour)
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
define jenkins::backup (
  $backup_location = undef,
  $hour = "*",
  $minute = "0",
) {

  #Add hour, minute as parameters
  $local_install_path = "/etc/puppet/"
  $local_install_dir  = "${local_install_path}installers/"
  $puppet_file_dir    = "modules/jenkins/"

  $backup_script = "jenkins-backup.sh"
  file{"backup-script-file":
    ensure => present,
    path => "${local_install_dir}${backup_script}",
    source => "puppet:///${puppet_file_dir}${$backup_script}",
  }
  cron { "cron-jenkins-backup":
    command => "${local_install_dir}${backup_script} ${backup_location}",
    user => 'root',
    hour => $hour,
    minute => $minute,
    require => File["backup-script-file"]
  }
#  exec{ "Perform-Jenkins-Folder-Backup":
#    path => "/usr/bin/",
#    command => "/usr/bin/rsync -a /var/lib/jenkins/* ${backup_location}$(/bin/date +%y-%m-%d-%H%M-jenkins-backup) --exclude /var/lib/jenkins/plugins/",
##    command => "rsync -a /var/lib/jenkins/* /vagrant/backup/$(ls -1 /vagrant/backup/ | tail -n1) --exclude /var/lib/jenkins/plugins/",
#    onlyif => "/bin/ls -1 /var/lib/jenkins"
##    require => Exec["create-jenkins-backup-dir"]
#  }
}

define jenkins::restore {
  #Get the latest backup dir
  #ls -1 /vagrant/backup/ | tail -n1
}
