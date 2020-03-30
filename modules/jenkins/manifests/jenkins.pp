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
$java_update_version = "242"

$maven_major_version="3"
$maven_minor_version="5"
$maven_patch_version="2"
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

class{'augeas':}
->
class{"augeas::xmlstarlet":}
->
class {'jenkins':
  major_version => "2",
  minor_version => "204",
  patch_version => "1",
  perform_manual_setup => false,
  plugin_backup_location => "/vagrant/backup/plugins/10-plugins/",
  java_major_version => "${java_major_version}",
  java_update_version => "${java_update_version}",
  job_backup_location => "/vagrant/backup/jobs/",
  jenkins_host_address => "http://jenkins.alexanderhopgood.com/",
}
->
class{"hiera":}
->
class{"hiera::eyaml":
  private_key_file => "private_key.pkcs7.pem",
  public_key_file => "public_key.pkcs7.pem",
}
->
jenkins::credentials::gitCredentials{"git-api-token":
  token_name => "github_token",
}
->
jenkins::seed_job{"seed-dsl":
  github_credentials_name => "github_token",
  github_dsl_job_url => "https://github.com/ahopgood/jenkins-ci.git"
}
->
jenkins::global::java_jdk{"Java-8":
  major_version => "${java_major_version}",
  update_version => "${java_update_version}",
  adoptOpenJDK => true,
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
class{"pandoc":}
->
pandoc::texlive_fonts_recommended{"texlive-fonts-recommended":}
->
pandoc::texlive_latex_extra{"texlive-latex-extra":}
->
pandoc::lmodern{"lmodern":}
->
Jenkins::Global::Labels { "labels":
  labels => "Java6 Java7 Java8 Pandoc Dos2Unix"
}
->
jenkins::credentials::ssh{"jenkins-ssh":
  key_name => "jenkins",
  ssh_creds_name => "jenkins_ssh"
}
->
class {"dos2unix":}
->
jenkins::global::reload::config{"set labels":
  password => "admin"
}