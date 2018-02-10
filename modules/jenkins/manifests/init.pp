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
  $plugin_backup = "") {

  $jenkins_short_ver     = "jenkins"
  $jenkins_group         = "${jenkins_short_ver}"
  $jenkins_user          = "${jenkins_short_ver}"

  $local_install_path = "/etc/puppet/"
  $local_install_dir  = "${local_install_path}installers/"
  $puppet_file_dir    = "modules/jenkins/"

#Ubuntu
#15.10 = wiley
#16.04 = Xenial
  if ($::operatingsystem) == 'CentOS' {
    notify {    "Using operating system:$::operatingsystem": }
  } elsif $::operatingsystem == "Ubuntu"{
    if $::operatingsystemmajrelease == "15.10" {
      notify{"We're on Ubuntu wiley trying to use Java package ${java_major_version}.${java_update_version}":}
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
        "set hudson.security.HudsonPrivateSecurityRealm_-Details/passwordHash/#text #jbcrypt:${password_bcrypt_hash}"
      ],
      require => [Package["jenkins"],Service["jenkins"], Exec["wait"]]
    }

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
      path => ["/bin/","/usr/bin/","/usr/local/bin/"],
      command => "/usr/local/bin/${restore_all_plugins_script} ${plugin_backup} /var/lib/jenkins/plugins/ >> /var/lib/jenkins/logs/${restore_all_plugins_script}.log 2>&1",
      require => File["${restore_all_plugins_script}"],
    }
    ->
    exec {"Restart Jenkins":
      path => ["/usr/sbin/","/etc/init.d/"],
      command => "jenkins restart",
    }
  }# Close manual check
}

define jenkins::gitCredentials(
  $git_hub_api_token = undef,
  $token_name = undef,
) {
  $credentials_file = "/var/lib/jenkins/credentials.xml"
  file {"${credentials_file}":
    ensure => present,
    mode => "755",
    group => "jenkins",
    owner => "jenkins",
    content => "<?xml version='1.0' encoding='UTF-8'?>\n<com.cloudbees.plugins.credentials.SystemCredentialsProvider></com.cloudbees.plugins.credentials.SystemCredentialsProvider>",
  }

  augeas { 'jenkins_git_credentials_config':
    show_diff => true,
    incl      => "${credentials_file}",
    lens      => 'Xml.lns',
    context   => '/files/var/lib/jenkins/credentials.xml/com.cloudbees.plugins.credentials.SystemCredentialsProvider/',
    require   => [File["/var/lib/jenkins/credentials.xml"]],
    changes   => [
      "set #attribute/plugin credentials@2.1.6",
      "set domainCredentialsMap/#attribute/class hudson.util.CopyOnWriteMap\$Hash",
      "set domainCredentialsMap/entry/com.cloudbees.plugins.credentials.domains.Domain/specifications #empty",
      "set domainCredentialsMap/entry/java.util.concurrent.CopyOnWriteArrayList/com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl/scope/#text \"GLOBAL\"",
      "set domainCredentialsMap/entry/java.util.concurrent.CopyOnWriteArrayList/com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl/id/#text \"${token_name}\"",
      "set domainCredentialsMap/entry/java.util.concurrent.CopyOnWriteArrayList/com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl/description/#text \"Github api token\"",
      "set domainCredentialsMap/entry/java.util.concurrent.CopyOnWriteArrayList/com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl/username/#text \"ahopgood\"",
      "set domainCredentialsMap/entry/java.util.concurrent.CopyOnWriteArrayList/com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl/password/#text \"${git_hub_api_token}\"",
    ]
  }
  ->
  augeas::formatXML{"format ${credentials_file}":
    filepath => "${credentials_file}"
  }
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
    "set project/triggers/hudson.triggers.SCMTrigger/spec/#text  H 4 * * *\n* * * * *",
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
  #   <scm class="hudson.plugins.git.GitSCM" plugin="git@3.7.0">
  #   <configVersion>2</configVersion>
  # <userRemoteConfigs>
  # <hudson.plugins.git.UserRemoteConfig>
  #   <url>https://github.com/ahopgood/jenkins-ci.git</url>
  # <credentialsId>github_token</credentialsId>
  # </hudson.plugins.git.UserRemoteConfig>
  #   </userRemoteConfigs>
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

define jenkins::java_jdk(
  $major_version = undef,
  $update_version = undef,
  $appendNewJdk = false,
){

  $jdk_name = "1.${major_version}.0_${update_version}"
  if (versioncmp("${operatingsystem}", "Ubuntu")){
    $jdk_location = "/usr/lib/jvm/jdk-${major_version}-oracle-x64/"
  } else {
    fail("Operating System [${operatingsystem}] is not supported for setting a Java Jdk")
  }
  if ($appendNewJdk == true){
    $changes = [
      "clear jdks",
      "set jdks/jdk[last()+1]/name/#text ${jdk_name}",
      "set jdks/jdk[last()]/home/#text  ${jdk_location}",
      "set jdks/jdk[last()]/properties #empty",
    ]
  } else {
    $changes = [
      "clear jdks",
      "rm jdks",
      "set jdks/jdk/name/#text ${jdk_name}",
      "set jdks/jdk/home/#text  ${jdk_location}",
      "set jdks/jdk/properties #empty",
    ]
  }

  augeas{ "jenkins_general_config_java_${major_version}_${update_version}":
    show_diff => true,
    incl => '/var/lib/jenkins/config.xml',
    lens => 'Xml.lns',
    context => '/files/var/lib/jenkins/config.xml/hudson/',
    changes => $changes,
          # require => [] #restart of jenkins service?
  }
  ->
  augeas::formatXML{"format /var/lib/jenkins/config.xml java ${jdk_name}":
    filepath => "/var/lib/jenkins/config.xml"
  }
  # <jdks>
  #   <jdk>
  #     <name>java 1.8</name>
  #     <home>/var/lib/jvm/jdk_1.8.0</home>
  #     <properties/>
  #   </jdk>
  #   <jdk>
  #     <name>java 1.9</name>
  #     <home>/var/lib/jvm/jdk_1.9.0</home>
  #     <properties/>
  #   </jdk>
  # </jdks>
}

define jenkins::maven(
$major_version = undef,
  $minor_version = undef,
  $patch_version = undef,
){
  $maven_name = "Maven-${major_version}-${minor_version}-${patch_version}"
  if (versioncmp("${operatingsystem}", "Ubuntu")){
    $maven_location = "/usr/share/maven${major_version}/"
  } else {
    fail("Operating System [${operatingsystem}] is not supported for setting maven tooling")
  }
  $puppet_file_dir        = "modules/jenkins/"
  $maven_config_file_name = "hudson.tasks.Maven.xml"
  $maven_config_file      = "/var/lib/jenkins/${maven_config_file_name}"

  file{"${maven_config_file_name}":
    source => "puppet:///${puppet_file_dir}${maven_config_file_name}",
    path => "${maven_config_file}",
    mode => "777",
    owner => "jenkins",
    group => "jenkins",
  }
  ->
  augeas { 'jenkins_general_config_maven':
    show_diff => true,
    incl      => "${maven_config_file}",
    lens      => 'Xml.lns',
    context   => "/files${maven_config_file}",
    changes   => [
      "set hudson.tasks.Maven_-DescriptorImpl/installations/hudson.tasks.Maven_-MavenInstallation/name/#text ${maven_name}",
      "set hudson.tasks.Maven_-DescriptorImpl/installations/hudson.tasks.Maven_-MavenInstallation/home/#text ${maven_location}",
      "set hudson.tasks.Maven_-DescriptorImpl/installations/hudson.tasks.Maven_-MavenInstallation/properties #empty",
    ],
  }
  ->
  augeas::formatXML{"${maven_config_file}":
    filepath => "${maven_config_file}"
  }
}