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
$java_major_version = "11"
$java_update_version = "6"

$maven_major_version="3"
$maven_minor_version="5"
$maven_patch_version="2"

$username = "jenkins";

file {
  "/etc/puppet/installers/":
    ensure     =>  directory,
}
->
#How do we create the back up location?
file {["/vagrant/","/vagrant/backup/","/vagrant/backup/jenkins/"]:
  ensure => directory,
}
->
# class { 'jenkins': 
#   perform_manual_setup => true,
#   plugin_backup => "/vagrant/backup/jenkins/",
# }
# ->
# sudo puppet apply --parser=future /vagrant/manifests/hiera_setup.pp
# sudo puppet apply --parser=future --hiera_config=/etc/puppet/hiera-eyaml.yaml /vagrant/manifests/jenkins.pp
# sudo puppet apply --parser=future /vagrant/manifests/hiera_setup.pp && sudo puppet apply --parser=future --hiera_config=/etc/puppet/hiera-eyaml.yaml /vagrant/manifests/jenkins.pp
# vagrant destroy Ubuntu_16_test -f && vagrant up Ubuntu_16_test
#  vagrant destroy Server_16 -f && vagrant up Server_16

class{'augeas':}
->
class{"augeas::xmlstarlet":}
->
class{"hiera":}
->
class{"hiera::eyaml":
  private_key_file => "private_key.pkcs7.pem",
  public_key_file => "public_key.pkcs7.pem",
}
->
class {'jenkins':
  # major_version => "2",
  # minor_version => "263",
  # patch_version => "3",
  major_version => "2",
  minor_version => "319",
  patch_version => "2",
  perform_manual_setup => false,
  plugin_backup_location => "/vagrant/backup/plugins/2022-09-28-1201-plugins/",
  java_major_version => "${java_major_version}",
  java_update_version => "${java_update_version}",
  job_backup_location => "/vagrant/backup/jobs/",
  jenkins_host_address => "http://jenkins.alexanderhopgood.com/",
}
->
jenkins::credentials::gitCredentials{"git-api-token":
  token_name => "github_token",
}
->
jenkins::credentials::ssh{"jenkins-ssh":
  key_name => "jenkins",
  ssh_creds_name => "jenkins_ssh"
}
->
jenkins::credentials::dockerRegistryCredentials{"docker-registry-creds":}
->
jenkins::credentials::dockerRegistryCredentials{"docker-hub-registry-creds":
  registryPassword => hiera('jenkins::dockerHubRegistry::credentials::password','test-hub-password'),
  registryUsername => hiera('jenkins::dockerHubRegistry::credentials::username','test-hub-username'),
  credentialsName => "docker-hub",
  registryAddress => hiera('jenkins::dockerHubRegistry::address', 'test-hub-address')
}
->
jenkins::seed_job{"seed-dsl":
  github_credentials_name => "github_token",
  github_dsl_job_url => "https://github.com/ahopgood/jenkins-ci.git"
}
->
jenkins::global::java_jdk{"Java-11":
  major_version => "11",
  update_version => "6",
  adoptOpenJDK => "true",
}
->
jenkins::backup_jobs{"backup-script":
  cron_hour => "*",
  cron_minute => "*/5",
  job_backup_location => "/vagrant/backup/jobs/"
}
->
class { 'maven':
  major_version => $maven_major_version,
  minor_version => $maven_minor_version,
  patch_version => $maven_patch_version,
}
->
jenkins::global::maven{"maven-global-setup":
  major_version => $maven_major_version,
  minor_version => $maven_minor_version,
  patch_version => $maven_patch_version,
}
->
maven::repository {"vagrant repository":
  user => $username
}
->
maven::repository::settings {"vagrant settings":
  user => $username,
  password => hiera('maven::repository::settings::server::password',''),
  repository_name => "reclusive-repo",
  repository_address => "https://artifactory.alexanderhopgood.com/artifactory/reclusive-repo",
}
->
maven::repository::settings::security {"vagrant settings security":
  user => $username,
  master_password => hiera('maven::repository::settings::security::master_password',''),
}
->
jenkins::docker::global{"docker-global-setup":}
->
jenkins::docker::workflow{"docker-workflow-setup":}
->
jenkins::docker::group{"Adding Jenkins to docker group":}
->
class{"pandoc":}
->
pandoc::texlive_fonts_recommended{"texlive-fonts-recommended":}
->
pandoc::texlive_latex_extra{"texlive-latex-extra":}
->
pandoc::lmodern{"lmodern":}
->
Jenkins::Global::Labels { "labels":
  labels => "Java6 Java7 Java8 Java11 Pandoc Dos2Unix Docker Grype Nomad Levant"
}
->
class {"dos2unix":}
->
class {"grype" : }
# ->
# jenkins::global::reload::config{"set labels":
#   password => "admin"
# }
# ->
# jenkins::global::restart{"restart":
#   password => "admin"
# }