$local_install_path = "/etc/puppet/"
$local_install_dir = "${local_install_path}installers/"
$java_major_version = "11"
$java_update_version = "6"

Package{
  allow_virtual => false,
}
file {
  "/etc/puppet/installers/":
    ensure     =>  directory,
}
->
#HOw do we create the back up location?
file {["/vagrant/","/vagrant/backup/","/vagrant/backup/jenkins/"]:
  ensure => directory,
}
class {'jenkins':
  # major_version => "2",
  # minor_version => "73",
  # patch_version => "1",
  major_version => "2",
  minor_version => "319",
  patch_version => "2",
  perform_manual_setup => false,
  plugin_backup_location => "/vagrant/backup/plugins/2022-09-28-1201-plugins/",
  java_major_version => "${java_major_version}",
  java_update_version => "${java_update_version}",
  job_backup_location => "/vagrant/backup/jobs/",
}
->
class{'augeas':}
->
class{"augeas::xmlstarlet":}
->
jenkins::docker::global{"docker-global-setup":}

$envHash = {
  "DOCKER_REGISTRY" => hiera('jenkins::dockerRegistry::address', 'test-address'),
  "NOMAD" => hiera('jenkins::nomad::address', 'test-address')
}
jenkins::global::env::var{"set-environmental-variables":
  envValuesHash => $envHash
}
->
jenkins::global::clouds::nomad{"setup-nomad-cloud":
  nomadHost => "https://nomad.test.alexanderhopgood.com",
  agentImage => 'altairbob/nomad-agent-docker-cli:20220915-130920',
  dockerInDockerImage => 'docker:dind',
  jenkinsHost => "192.168.1.30",
  labels => "Java6 Java7 Java8 Java9 Java10 Java11 Java12 Java13 Java14 Java15 Java16 Java17 docker"
}
# ->
# jenkins::docker::workflow{"docker-workflow-setup":}

# class { "nomad":
#   major_version => "1",
#   minor_version => "2",
#   patch_version => "6"
# }
# ->
# nomad::levant{"levant-install":
#   major_version => "0",
#   minor_version => "3",
#   patch_version => "1"
# }
#
# Jenkins::Global::Labels { "labels":
#   labels => "Java6 Java7 Java8 Java11 Docker Grype Nomad Levant"
# }
# ->
# jenkins::global::reload::config{"set labels":
#   password => "admin"
# }