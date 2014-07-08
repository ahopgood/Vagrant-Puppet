#Setup the fileserver config so we can serve files via the puppet fileserver
file {
  '/etc/puppet/fileserver.conf':
  ensure      =>  present,
  source      => '/vagrant/fileserver.conf',
}
#Ensure the destination directory for the installers is present
file {
  '/etc/puppet/installers/':
  ensure      =>  directory,
  mode        =>  0666,
#  owner       =>  'installer',
}