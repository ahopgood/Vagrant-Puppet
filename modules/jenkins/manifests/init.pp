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
  $major_version = "2",
  $minor_version = "19",
  $patch_version = "1",
  $perform_manual_setup = false,
  $password_bcrypt_hash = "\$2a\$10\$2dr50M9GvFH49WjsOASfCe3dOVctegmK8SRtAJEIrzSPbjSTGhfka", #admin
  $backup_location = "",
  $plugin_backup = "") {

  $jenkins_short_ver     = "jenkins"
  $jenkins_group         = "${jenkins_short_ver}"
  $jenkins_user          = "${jenkins_short_ver}"

  $local_install_path = "/etc/puppet/"
  $local_install_dir  = "${local_install_path}installers/"
  $puppet_file_dir    = "modules/jenkins/"

  $java_major_version = "8"
  $java_update_version = "112"

#Ubuntu
#15.10 = wiley
#16.04 = Xenial
  if ($::operatingsystem) == 'CentOS' {
    notify {    "Using operating system:$::operatingsystem": }
  } elsif $::operatingsystem == "Ubuntu"{
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
  
  #Requires java to be installed,
  #running the module again causes issues as the java module removes old versions before installing Java again which is a dependency of Jenkins and causes a failure
  java{"install-java":
    major_version => "${java_major_version}",
    update_version => "${java_update_version}",
  }

  $daemon_major_version = "6"
  $daemon_minor_version = "4"
  $daemon_patch_version = "1"
  $daemon = "daemon_0.${daemon_major_version}.${daemon_minor_version}-${daemon_patch_version}_amd64.deb"

  file {
    "${daemon}":
    require    =>  File["${local_install_dir}"],
    path       =>  "${local_install_dir}${daemon}",
    ensure     => present,
    source     =>  ["puppet:///${puppet_file_dir}${daemon}"]
  }
  
  package {
    "daemon":
    provider => "dpkg",
    # ensure => "${daemon_major_version}.${daemon_minor_version}-${daemon_patch_version}",
    ensure => installed,
    source => "${local_install_dir}${daemon}",
    require => File["${daemon}"]
  }

  
  $jenkins = "jenkins_${major_version}.${minor_version}.${patch_version}_all.deb"
  file {
    "${jenkins}":
    require    =>  File["${local_install_dir}"],
    path       =>  "${local_install_dir}${jenkins}",
    ensure     => present,
    source     =>  ["puppet:///${puppet_file_dir}${jenkins}"]
  }
  
  package {
    "jenkins":
    provider => "dpkg",
    # ensure => "${major_version}.${minor_version}.${patch_version}",
    ensure => installed,
    source => "${local_install_dir}${jenkins}",
    require => [File["${jenkins}"], Package["daemon"], Java["install-java"]]
  }

  service {
    "jenkins":
      enable => true,
      ensure => running,
      require => Package["jenkins"],
  }
  ->
  exec { "wait":
    command => "/bin/sleep 20",
  }
  $backup_script="backup-plugins.sh"
  file {"${backup_script}":
    require => File["${local_install_dir}"],
    ensure => present,
    path => "/usr/local/bin/${backup_script}",
    source => ["puppet:///${puppet_file_dir}${backup_script}"]
  }
  #iptables port exemption needed

  if ($perform_manual_setup == true){
    #Perform manual setup & configure back up program but not restore
    #1. Script to create plugins.txt: 
      # 1.1 use find to locate files with .hpi & .jpi extensions
      # 1.2 use cat & grep to find the version from the exploded manifest
      # 1.4 calculate the hash
      # 1.5 if file already contains the plugin, don't overwrite. If the hash doesn't match then blank the hash
      # 1.6 wire up script with cron
    cron {"schedule-backup":
      command => "/usr/local/bin/${backup_script} ${plugin_backup} >> /var/lib/jenkins/logs/${backup_script}.log 2>&1",
      minute => "*/5",
      user => 'root',
      require => File["${backup_script}"],
    }
  } else {
    # 1. Insert existing user hash
    # 2. Restore from list of plugins found in plugins.txt
      # 2.1 read through plugins.txt using cat
      # 2.1 for each plugin check if it exists in the backup location
      # 2.3 check if the hash matches, then copy
      # 2.4 if the hash doesn't match or is missing then pull from the jenkins update centre
      # 2.5 update the plugins.txt file entry with the hash
    #admin
    # 
    augeas{ 'jenkins_admin_config':
      show_diff => true,
      incl => '/var/lib/jenkins/users/admin/config.xml',
      lens => 'Xml.lns',
      context => '/files/var/lib/jenkins/users/admin/config.xml/user/properties/',
      changes => [
        # 'set hudson.security.HudsonPrivateSecurityRealm_-Details',
        # 'set hudson.security.HudsonPrivateSecurityRealm_-Details/passwordHash',
        "set hudson.security.HudsonPrivateSecurityRealm_-Details/passwordHash/#text #jbcrypt:${password_bcrypt_hash}"
        #     'set authorizationStrategy/#attribute/class hudson.security.FullControlOnceLoggedInAuthorizationStrategy',
        #     'rm securityRealm/#empty',
        #     'set securityRealm/#attribute/class hudson.plugins.active_directory.ActiveDirectorySecurityRealm',
        #     'set securityRealm/#attribute/plugin active-directory@1.42',
        #     'touch securityRealm/removeIrrelevantGroups',
        #     'touch securityRealm/groupLookupStrategy',
        #     'set securityRealm/groupLookupStrategy/#text AUTO',
        #     'set securityRealm/removeIrrelevantGroups/#text false',
      ],
      # onlyif => "",
      require => [Package["jenkins"],Service["jenkins"], Exec["wait"]]
    }
    #set /files/var/lib/jenkins/users/admin/config.xml/user/properties/hudson.security.HudsonPrivateSecurityRealm_-Details/passwordHash/#text #jbcrypt:$2a$10$2dr50M9GvFH49WjsOASfCe3dOVctegmK8SRtAJEIrzSPbjSTGhfka
    #sudo puppet apply --parser=future --debug /vagrant/manifests/jenkins.pp
    #sudo puppet apply --parser=future /vagrant/manifests/jenkins.pp
    #sudo apt-get install augeas-tools
    #sudo augtool -At "Xml.lns incl /var/lib/jenkins/users/admin/config.xml"
    # <hudson.security.HudsonPrivateSecurityRealm_-Details>
    # <passwordHash>#jbcrypt:$2a$10$w1rRmLGv5zeEEGeZBbG.3.4dSHWN6Rv9SZdgthf69k9fiJ4g0c.xG</passwordHash>
    #set "/files/var/lib/jenkins/users/admin/config.xml/user/properties/hudson.security.HudsonPrivateSecurityRealm_-Details/passwordHash/#text", "#jbcrypt:$2a$10$2dr50M9GvFH49WjsOASfCe3dOVctegmK8SRtAJEIrzSPbjSTGhfka"
    $restore_plugin_script="retrieve-plugin.sh"
    $restore_all_plugins_script="retrieve-all-plugins.sh"
    
    file {"jenkins.install.InstallUtil.lastExecVersion":
      ensure => present,
      mode => "755",
      owner => "jenkins",
      group => "jenkins",
      require => [File["${local_install_dir}"],Package["jenkins"], Exec["wait"]],
      content => "$major_version.$minor_version.$patch_version",
      path => "/var/lib/jenkins/jenkins.install.InstallUtil.lastExecVersion",
    }
    ->
    file {"${restore_plugin_script}":
      ensure => present,
      require => [Augeas['jenkins_admin_config']],
      path => "/usr/local/bin/${restore_plugin_script}",
      source => "puppet:///${puppet_file_dir}${restore_plugin_script}",
    }
    file {"${restore_all_plugins_script}":
      ensure => present,
      require => [File["${local_install_dir}"],File["${restore_plugin_script}"]],
      path => "/usr/local/bin/${restore_all_plugins_script}",
      source => "puppet:///${puppet_file_dir}${restore_all_plugins_script}",
    }
    exec {"Restore plugins":
      #user => 'root',
      path => ["/bin/","/usr/bin/"],
      #cwd => "/usr/local/bin/",
      command => "/usr/local/bin/${restore_all_plugins_script} ${plugin_backup} /var/lib/jenkins/plugins/ >> /var/lib/jenkins/logs/${restore_all_plugins_script}.log 2>&1",
      require => File["${restore_all_plugins_script}"],
    }
    ->
    exec {"Restart Jenkins":
      #user => 'root',
      path => ["/usr/sbin/","/etc/init.d/"],
      command => "jenkins restart",
    }
  }
}
