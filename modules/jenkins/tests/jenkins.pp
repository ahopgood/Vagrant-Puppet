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
  minor_version => "263",
  patch_version => "3",
  perform_manual_setup => false,
  plugin_backup_location => "/vagrant/backup/plugins/05-plugins/",
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