$local_install_path = "/etc/puppet/"
$local_install_dir = "${local_install_path}installers/"
$java_major_version = "8"
$java_update_version = "242"

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
# jenkins::docker::global{"docker-global-setup":}
# ->
jenkins::docker::workflow{"docker-workflow-setup":}
