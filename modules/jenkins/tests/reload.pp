$local_install_path = "/etc/puppet/"
$local_install_dir = "${local_install_path}installers/"
Package{
  allow_virtual => false,
}
file {
  "/etc/puppet/installers/":
    ensure     =>  directory,
}
->
file {["/vagrant/","/vagrant/backup/","/vagrant/backup/jenkins/"]:
  ensure => directory,
}
->
class{"augeas::xmlstarlet":}
->
class {'jenkins':
  major_version => "2",
  minor_version => "73",
  patch_version => "1",
  perform_manual_setup => false,
  plugin_backup_location => "/vagrant/backup/plugins/05-plugins/",
  java_major_version => "8",
  java_update_version => "112",
  job_backup_location => "/vagrant/backup/jobs/",
}
->
jenkins::global::reload::config{"set labels":}
->
jenkins::global::reload::config{"set labels again":}