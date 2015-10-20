# Class: kanboard
#
# This module manages kanboard
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class kanboard {
  #mysql
  
  Class['mysql'] -> Class['kanboard']
     
  package {"httpd":
    ensure => present,
    provider => 'yum'
    #version 2.2.15
  }
  package {"php":
    ensure => present,
    provider => 'yum'
    #version 5.3.3
  }
  package {"php-mbstring":
    ensure => present,
    provider => 'yum'
  }  
  package {"php-pdo":
    ensure => present,
    provider => 'yum'
  }
  package {"php-gd":
    ensure => present,
    provider => 'yum'
    #2.0.34
  }
  package {"php-mysql":
    ensure => present,
    provider => 'yum'
    #5.1.73
  }
  package {"unzip":
    ensure => present,
    provider => 'yum'
    #6.00
  }
  package {"wget":
    ensure => present,
    provider => 'yum'
    #1.12
  }
  
  $puppet_file_dir    = "modules/kanboard/"
  file{"install.sh":
    ensure => present,
    path => "/usr/local/bin/install.sh",
    source => ["puppet:///${puppet_file_dir}install.sh"]
  }

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }
  
  exec{
    "install":
    command => "/usr/local/bin/install.sh",
    cwd => "/home/vagrant",
    notify => Service["httpd"]
  }
  
  service {
    "httpd":
    ensure => running,
    enable => true
  }
  
  notify {
    "Kanboard":
  }
}