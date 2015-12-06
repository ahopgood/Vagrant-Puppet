Package{
  allow_virtual => false
}

class {'mysql':}

#class {'httpd':}

class {'kanboard':
  backup_path => "/vagrant/backups/"
}

