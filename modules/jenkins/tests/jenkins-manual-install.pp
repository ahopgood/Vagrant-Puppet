Package{
  allow_virtual => false,
}
file {
  "/etc/puppet/installers/":
    ensure     =>  directory,
}
->
class { 'jenkins':
  perform_manual_setup => true,
  plugins_file => "/vagrant/tests/plugins.txt",
  plugins_backup => "/vagrant/tests/backup/"
}