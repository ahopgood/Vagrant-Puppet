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

$local_install_path = "/etc/puppet/"
$local_install_dir = "${local_install_path}installers/"
Package{
  allow_virtual => false,
}
$java_major_version = "8"
$java_update_version = "112"

$maven_major_version="3"
$maven_minor_version="0"
$maven_patch_version="5"
file {
  "/etc/puppet/installers/":
    ensure     =>  directory,
}
->
#HOw do we create the back up location?
file {["/vagrant/","/vagrant/backup/","/vagrant/backup/jenkins/"]:
  ensure => directory,
}
->
# class { 'jenkins': 
#   perform_manual_setup => true,
#   plugin_backup => "/vagrant/backup/jenkins/",
# }
# ->
# sudo puppet apply --parser=future /vagrant/manifests/jenkins.pp
class{"augeas::xmlstarlet":}
->
class {'jenkins':
  perform_manual_setup => false,
  plugin_backup => "/vagrant/backup/plugins/02-plugins/",
  java_major_version => "${java_major_version}",
  java_update_version => "${java_update_version}",
}
->
jenkins::gitCredentials{"git-api-token":
  git_hub_api_token => "215cef666c89c2425128abcf8cb842ebaee99054",
  token_name => "github_token",
}
->
jenkins::seed_job{"seed-dsl":
  github_credentials_name => "github_token",
  github_dsl_job_url => "https://github.com/ahopgood/jenkins-ci.git"
}
->
jenkins::java_jdk{"Java-8":
  major_version => "${java_major_version}",
  update_version => "${java_update_version}",
}
->
jenkins::global::java_jdk{"Java-7":
  major_version => "7",
  update_version => "173",
  appendNewJdk => true,
}
->
jenkins::global::java_jdk{"Java-6":
  major_version => "6",
  update_version => "99",
  appendNewJdk => true,
}
jenkins::backup_jobs{"backup-script":
  cron_hour => "19",
  cron_minute => "24",
  # job_backup_location => "/home/vagrant/backups/"
}
->
class { 'maven':
  major_version => $maven_major_version,
  minor_version => $maven_minor_version,
  patch_version => $maven_patch_version,
}
->
class{'augeas':}
->
jenkins::maven{"maven-global-setup":
  major_version => $maven_major_version,
  minor_version => $maven_minor_version,
  patch_version => $maven_patch_version,
}

