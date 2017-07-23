# Class: ufw
#
# This module manages ufw
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
define ufw (
  $port = undef,
  $isTCP = undef,
) {
  if ("${operatingsystem}" != "Ubuntu"){
    fail("Operating System not supported ${operatingsystem}")
  }
  
  if ("${isTCP}" == "true"){
    $protocol = "tcp"
  } else {
    $protocol = "udp"
  }

  exec {"add firewall rule ${port}/${protocol}":
    path => "/usr/sbin/",
    command => "ufw allow ${port}/${protocol}",
    unless => "ufw status | /bin/grep ${port}/${protocol} .* ALLOW"
  }
  ->
  exec { "Enable Firewall [${name}]":
    path    => "/usr/sbin/",
    command => "ufw --force enable",
    onlyif  => "ufw status | /bin/grep inactive",
    notify  => Service["ufw"],
    before => Ufw::Service["ufw-service"],
  }
}

define ufw::service{
  service {"ufw":
    ensure => running,
    enable => true,
  }
}