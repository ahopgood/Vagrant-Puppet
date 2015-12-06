Package{
  allow_virtual => false
}

class {'mysql':}

class {'kanboard':
  backup_path => "/vagrant/backups/"
}

