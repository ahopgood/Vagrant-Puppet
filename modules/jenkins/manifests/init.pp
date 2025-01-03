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
  $java_major_version = undef,
  $java_update_version = undef,
  $password_bcrypt_hash = "\$2a\$10\$2dr50M9GvFH49WjsOASfCe3dOVctegmK8SRtAJEIrzSPbjSTGhfka", #admin
  $plugin_backup_location = "",
  $job_backup_location = undef,
  $jenkins_host_address = "http://localhost:8080/",
) {

  $jenkins_short_ver     = "jenkins"
  $jenkins_group         = "${jenkins_short_ver}"
  $jenkins_user          = "${jenkins_short_ver}"

  $local_install_path = "/etc/puppet/"
  $local_install_dir  = "${local_install_path}installers/"
  $puppet_file_dir    = "modules/jenkins/"

  if ($::operatingsystem) == 'CentOS' {
    notify {    "Using operating system:$::operatingsystem": }
  } elsif $::operatingsystem == "Ubuntu"{
    if $::operatingsystemmajrelease == "15.10" { #Ubuntu wily
      notify{"We're on Ubuntu wiley trying to use Java package ${java_major_version}.${java_update_version}":}
    } elsif $::operatingsystemmajrelease == "16.04" { #Ubuntu Xenial
      notify{"We're on Ubuntu xenial trying to use Java package ${java_major_version}.${java_update_version}":}



      # dpkg: dependency problems prevent configuration of jenkins:
      # jenkins depends on default-jre-headless (>= 2:1.8) | java8-runtime-headless; however:
      # Package default-jre-headless is not installed. - 2:1.8-56ubuntu2
      # Package java8-runtime-headless is not installed.
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

  $restore_plugin_script="retrieve-plugin.sh"
  $restore_all_plugins_script="retrieve-all-plugins.sh"
  $restore_jobs_script="restore-jobs.sh"

  $jenkins = "jenkins_${major_version}.${minor_version}.${patch_version}_all.deb"
  file {
    "${jenkins}":
    require    =>  File["${local_install_dir}"],
    path       =>  "${local_install_dir}${jenkins}",
    ensure     => present,
    source     =>  ["puppet:///${puppet_file_dir}${jenkins}"]
  }
  
  package {    "jenkins":
    provider => "dpkg",
    # ensure => installed,
    ensure => latest,
    source => "${local_install_dir}${jenkins}",
    require => [File["${jenkins}"], Package["daemon"], Java["install-java"]]
  }
  ->
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
  $backup_script = "backup-plugins.sh"
  file {"${backup_script}":
    ensure => present,
    mode => "755",
    owner => "jenkins",
    group => "jenkins",
    require => File["${local_install_dir}"],
    path => "/usr/local/bin/${backup_script}",
    source => ["puppet:///${puppet_file_dir}${backup_script}"]
  }

  file {"/var/lib/jenkins/logs/":
    ensure => directory,
    owner => "jenkins",
    group => "jenkins",
    mode => "0777",
    require => [Package["jenkins"],]
  }
  # iptables port exemption needed?
  if ($perform_manual_setup == true){
    cron {"schedule-backup":
      command => "/usr/local/bin/${backup_script} ${plugin_backup_location} >> /var/lib/jenkins/logs/${backup_script}.log 2>&1",
      minute => "*/5",
      user => 'root',
      require => File["${backup_script}"],
    }
  } else {
    if (versioncmp("${major_version}.${minor_version}.${patch_version}", "2.138.4") < 0) {
      augeas { 'jenkins_admin_config':
        show_diff => true,
        incl      => '/var/lib/jenkins/users/admin/config.xml',
        lens      => 'Xml.lns',
        context   => '/files/var/lib/jenkins/users/admin/config.xml/user/properties/',
        changes   => [
          "set hudson.security.HudsonPrivateSecurityRealm_-Details/passwordHash/#text #jbcrypt:${password_bcrypt_hash}"
        ],
        before    => File["${restore_plugin_script}"],
        require   => [Package["jenkins"], Service["jenkins"], Exec["wait"]]
      }
    }
    elsif (versioncmp("${major_version}.${minor_version}.${patch_version}", "2.138.4") > 0)
      and (versioncmp("${major_version}.${minor_version}.${patch_version}", "2.332.1") < 0) {
      file {"/var/lib/jenkins/users/":
        ensure => directory,
        owner => "jenkins",
        group => "jenkins",
        recurse => true,
        recurselimit => "2",
        mode => "0755",
        require => [
          Package["jenkins"],
        ]
      }

      file {"/usr/local/bin/setAdminPassword.sh":
        ensure => file,
        owner => "jenkins",
        group => "jenkins",
        mode => "0755",
        source => "puppet:///${puppet_file_dir}setAdminPassword.sh",
        require => [
          Package["jenkins"],
          Service["jenkins"],
          File["/var/lib/jenkins/users/"],
          File["/var/lib/jenkins/jenkins.install.UpgradeWizard.state"],
          Exec["wait"],
        ]
      }
      ->
      exec {"jenkins_admin_config":
        path => ["/usr/local/bin/", "/bin/", "/usr/bin/"],
        user => "root",
        command => "bash setAdminPassword.sh '${password_bcrypt_hash}'",
        before => File["${restore_plugin_script}"],
        require => [
          File["/usr/local/bin/setAdminPassword.sh"],
        ]
      }
    } else {
      file{"/var/lib/jenkins/init.groovy.d/":
        ensure => directory,
        mode => "777",
        owner => "jenkins",
        group => "jenkins",
        require => [
          File["${local_install_dir}"],
          Package["jenkins"],
          # Exec["wait"]
        ],
        before => [
          Service["jenkins"],
        ]
      }
      ->
      file {"/var/lib/jenkins/init.groovy.d/basic-security.groovy":
        ensure => present,
        mode => "755",
        owner => "jenkins",
        group => "jenkins",
        require => [
          File["${local_install_dir}"],
          Package["jenkins"],
          File["/var/lib/jenkins/jenkins.install.UpgradeWizard.state"],
          # Exec["wait"]
        ],
        source => "puppet:///${puppet_file_dir}basic-security.groovy",
        path => "/var/lib/jenkins/init.groovy.d/basic-security.groovy",
      }
      ->
      file_line { "add hashed password":
        path => "/var/lib/jenkins/init.groovy.d/basic-security.groovy",
        line => "hudsonRealm.createAccountWithHashedPassword('admin','#jbcrypt:${password_bcrypt_hash}')",
        match => "^hudsonRealm\.createAccountWithHashedPassword\('admin','PASSWORD_PLACEHOLDER'\)"
      }
      ->
      exec {"Restart Jenkins for password reset":
        path => ["/bin/"],
        command => "systemctl restart jenkins",
      }
      #   Need a restart for this to stick?
    } #End admin user version check

    if (versioncmp("${major_version}.${minor_version}.${patch_version}", "2.277.1") >= 0) {
      # and (versioncmp("${major_version}.${minor_version}.${patch_version}", "2.387.3") < 0) {
      # version 2.387 onwards does this via the groovy init script
      # Mark Jenkins as an existing running service to avoid going through the setup wizard
      file {'/var/lib/jenkins/jenkins.install.UpgradeWizard.state':
        content => "${major_version}.${minor_version}.${patch_version}",
        mode => "755",
        ensure => "file",
        owner => "jenkins",
        group => "jenkins",
        require   => [
          Package["jenkins"],
          Service["jenkins"],
          Exec["wait"],
          # Exec["Restore plugins"],
        ]
      }
    } else {
      # Mark Jenkins as an existing running service to avoid going through the setup wizard
      augeas { 'jenkins-config':
        show_diff => true,
        incl      => '/var/lib/jenkins/config.xml',
        lens      => 'Xml.lns',
        context   => '/files/var/lib/jenkins/config.xml/',
        changes   => [
          "set hudson/installStateName/#text RUNNING"
        ],
        # before    => Exec["Restore plugins"],
        require   => [
          Package["jenkins"],
          Service["jenkins"],
          Exec["wait"],
          Exec["Restore plugins"],
        ]
      }
    }

    if (versioncmp("${major_version}.${minor_version}.${patch_version}", "2.121.1") >= 0) {
      $location_configuration_filename = "jenkins.model.JenkinsLocationConfiguration.xml"
      file {"${location_configuration_filename}":
        ensure => file,
        path => "/var/lib/jenkins/${location_configuration_filename}",
        owner => "jenkins",
        group => "jenkins",
        mode => "0755",
        source => "puppet:///${puppet_file_dir}${location_configuration_filename}",
        require   => [
          Package["jenkins"],
          Service["jenkins"],
          Exec["wait"],
        ]
      }

      augeas { "Configure ${location_configuration_filename}":
        show_diff => true,
        incl      => "/var/lib/jenkins/${location_configuration_filename}",
        lens      => 'Xml.lns',
        context   => "/files/var/lib/jenkins/${location_configuration_filename}/",
        changes   => [
          "set jenkins.model.JenkinsLocationConfiguration/#text[1] '\n   '",
          "set jenkins.model.JenkinsLocationConfiguration/jenkinsUrl/#text ${jenkins_host_address}",
          "set jenkins.model.JenkinsLocationConfiguration/#text[2] '\n'",
        ],
        before    => Exec["Restore plugins"],
        require   => [
          Package["jenkins"],
          Service["jenkins"],
          Exec["wait"],
          File["${location_configuration_filename}"],
        ]
      }
    }

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
    file {"jenkins.install.runSetupWizard":
      ensure => present,
      mode => "755",
      owner => "jenkins",
      group => "jenkins",
      require => [
        File["${local_install_dir}"],
        Package["jenkins"],
        # Exec["wait"]
      ],
      content => "false",
      path => "/var/lib/jenkins/jenkins.install.runSetupWizard",
    }
    ->
    file_line { "disable setup wizard":
      path => "/etc/default/jenkins",
      line => 'JENKINS_ARGS="--webroot=/var/cache/$NAME/war --httpPort=$HTTP_PORT -Djenkins.install.runSetupWizard=false"',
      match => '^JENKINS_ARGS="--webroot=/var/cache/$NAME/war --httpPort=$HTTP_PORT"$'
    }
    ->
    file {"${restore_plugin_script}":
      ensure => present,
      mode => "755",
      owner => "jenkins",
      group => "jenkins",
      path => "/usr/local/bin/${restore_plugin_script}",
      source => "puppet:///${puppet_file_dir}${restore_plugin_script}",
    }
    file {"${restore_all_plugins_script}":
      ensure => present,
      mode => "755",
      owner => "jenkins",
      group => "jenkins",
      require => [File["${local_install_dir}"],File["${restore_plugin_script}"]],
      path => "/usr/local/bin/${restore_all_plugins_script}",
      source => "puppet:///${puppet_file_dir}${restore_all_plugins_script}",
    }
    exec {"Restore plugins":
      path => ["/bin/","/usr/bin/","/usr/local/bin/"],
      user => 'jenkins',
      command => "/usr/local/bin/${restore_all_plugins_script} ${plugin_backup_location} /var/lib/jenkins/plugins/ >> /var/lib/jenkins/logs/${restore_all_plugins_script}.log 2>&1",
      require => File["${restore_all_plugins_script}"],
    }
    ->
    file {"${restore_jobs_script}":
      ensure => present,
      mode => "755",
      owner => "jenkins",
      group => "jenkins",
      require => File["${local_install_dir}"],
      path => "/usr/local/bin/${restore_jobs_script}",
      source => "puppet:///${puppet_file_dir}${restore_jobs_script}"
    }
    ->
    exec {"Restore jobs":
      path => ["/bin/","/usr/bin/","/usr/local/bin/"],
      command => "/usr/local/bin/${restore_jobs_script} ${job_backup_location} /var/lib/jenkins/jobs/ >> /var/lib/jenkins/logs/${restore_jobs_script}.log 2>&1",
      require => File["${restore_jobs_script}"],
    }
    ->
    exec {"Set ownership of jobs":
      path => ["/bin/","/usr/bin/","/usr/local/bin/"],
      command => "chown -R jenkins:jenkins /var/lib/jenkins/jobs/",
      require => Exec["Restore jobs"]
    }
    ->
    exec {"Restart Jenkins":
      path => ["/usr/sbin/","/etc/init.d/"],
      command => "jenkins restart",
    }
  }# Close manual check
}

define jenkins::seed_job(
  $github_dsl_job_url = undef,
  $github_credentials_name = undef,
){
  if ($github_dsl_job_url == undef){
    fail("A url for the DSL job in jenkins is required")
  }

  if ($github_credentials_name == undef){
    fail("A named set of github credentials are required")
  }

  $puppet_file_dir    = "modules/jenkins/"
  $job_name = "jenkins-ci"

  file{"disable-job-security":
    ensure => present,
    source => "puppet:///${puppet_file_dir}disable-job-security.xml",
    path => "/var/lib/jenkins/javaposse.jobdsl.plugin.GlobalJobDslSecurityConfiguration.xml",
    mode => "777",
    owner => "jenkins",
    group => "jenkins",
    before => File["/var/lib/jenkins/jobs/${job_name}"]
  }

  file{["/var/lib/jenkins/jobs/",
    "/var/lib/jenkins/jobs/${job_name}"]:
    ensure => directory,
    mode => "777",
    owner => "jenkins",
    group => "jenkins",
  }
  ->
  file{"${job_name}/config.xml":
    source => "puppet:///${puppet_file_dir}job-config.xml",
    path => "/var/lib/jenkins/jobs/${job_name}/config.xml",
    mode => "777",
    owner => "jenkins",
    group => "jenkins",
    before => Augeas["create-seed-job-config.xml"]
  }

  $changes = [
    "set project/actions/ #empty",
    "set project/description/#text \"A seed job for creating jobs using the netflix Jenkins DSL.\"",
    "set project/keepDependencies/#text false",
    "set project/properties/ #empty",
    "set project/scm/#attribute/class hudson.plugins.git.GitSCM",
    "set project/scm/#attribute/plugin git@3.7.0",
    "set project/scm/configVersion/#text 2",
    "set project/scm/userRemoteConfigs/hudson.plugins.git.UserRemoteConfig/url/#text ${github_dsl_job_url}",
    "set project/scm/userRemoteConfigs/hudson.plugins.git.UserRemoteConfig/credentialsId/#text ${github_credentials_name}",
    "set project/scm/branches/hudson.plugins.git.BranchSpec/name/#text */master",
    "set project/scm/doGenerateSubmoduleConfigurations/#text false",
    "set project/scm/submoduleCfg #empty",
    "set project/scm/submoduleCfg/#attribute/class list",
    "set project/scm/extensions #empty",
    "set project/canRoam/#text true",
    "set project/disabled/#text false",
    "set project/blockBuildWhenDownstreamBuilding/#text false",
    "set project/blockBuildWhenUpstreamBuilding/#text false",
    "set project/concurrentBuild/#text false",
    "set project/triggers/hudson.triggers.SCMTrigger/spec/#text  \"H 4 * * *\n* * * * *\"",
    "set project/builders/javaposse.jobdsl.plugin.ExecuteDslScripts/#attribute/plugin job-dsl@1.66",
    "set project/builders/javaposse.jobdsl.plugin.ExecuteDslScripts/targets/#text **/*.groovy",
    "set project/builders/javaposse.jobdsl.plugin.ExecuteDslScripts/usingScriptText/#text false",
    "set project/builders/javaposse.jobdsl.plugin.ExecuteDslScripts/sandbox/#text true",
    "set project/builders/javaposse.jobdsl.plugin.ExecuteDslScripts/ignoreExisting/#text false",
    "set project/builders/javaposse.jobdsl.plugin.ExecuteDslScripts/ignoreMissingFiles/#text false",
    "set project/builders/javaposse.jobdsl.plugin.ExecuteDslScripts/failOnMissingPlugin/#text false",
    "set project/builders/javaposse.jobdsl.plugin.ExecuteDslScripts/unstableOnDeprecation/#text false",
    "set project/builders/javaposse.jobdsl.plugin.ExecuteDslScripts/removedJobAction/#text IGNORE",
    "set project/builders/javaposse.jobdsl.plugin.ExecuteDslScripts/removedViewAction/#text IGNORE",
    "set project/builders/javaposse.jobdsl.plugin.ExecuteDslScripts/removedConfigFilesAction/#text IGNORE",
    "set project/builders/javaposse.jobdsl.plugin.ExecuteDslScripts/lookupStrategy/#text JENKINS_ROOT",
    "set project/publishers #empty",
    "set project/buildWrappers #empty",
  ]

  augeas{"create-seed-job-config.xml":
    show_diff => true,
    incl => "/var/lib/jenkins/jobs/${job_name}/config.xml",
    lens => 'Xml.lns',
    context => "/files/var/lib/jenkins/jobs/${job_name}/config.xml/",
    changes => $changes,
  }
  ->
  augeas::formatXML{"format /var/lib/jenkins/jobs/${job_name}/config.xml":
    filepath => "/var/lib/jenkins/jobs/${job_name}/config.xml"
  }
  #https://stackoverflow.com/questions/44884121/jenkins-disable-tag-every-build-in-dsl
  #Manage Jenkins >> Configure Global Security >> Access Control for Builds >> Project default Build Authorization
  #Choose Run as the specified user >> admin, jenkins
}

define jenkins::backup_jobs(
  $cron_hour = "*",
  $cron_minute = "0",
  $job_backup_location = undef
){
  $backup_job_script = "backup-jobs.sh"
  file{"${backup_job_script}":
    ensure => present,
    mode => "755",
    owner => "jenkins",
    group => "jenkins",
    source => "puppet:///${jenkins::puppet_file_dir}${backup_job_script}",
    path => "/usr/local/bin/${backup_job_script}"
  }

  if ($job_backup_location == undef){
    $backup_enabled = "absent"
  } else {
    $backup_enabled = "present"
  }
  cron {"schedule-backup-jobs":
    command => "/usr/local/bin/${backup_job_script} ${job_backup_location} >> /var/lib/jenkins/logs/${backup_job_script}.log 2>&1",
    hour => "${cron_hour}",
    minute => "${cron_minute}",
    ensure => "${backup_enabled}",
    user => 'root',
    require => File["${backup_job_script}"],
  }
}
