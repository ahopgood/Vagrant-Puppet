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
   
  package {"httpd":
    ensure => present,
    provider => 'yum'
  }
  package {"php":
    ensure => present,
    provider => 'yum'
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
  }
  package {"unzip":
    ensure => present,
    provider => 'yum'
  }
  package {"wget":
    ensure => present,
    provider => 'yum'
  }
  notify {
    "Kanboard":
  }
}