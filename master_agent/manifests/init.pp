# Class: master_agent
#
# This module manages master_agent
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class master_agent {
  service { "iptables":
    enable  =>  false,
    ensure  => stopped,
  }
  
  host { "agent.vm":
    ip            =>  "192.168.33.13",
  }

  host { "agentweb.vm":
    ip            =>  "192.168.33.12",
  }
  
  file {  "Set puppet ownership":
    path      =>  "/usr/bin/puppet",
    owner     =>  "vagrant",
    group     =>  "vagrant",
  }
  
#  service { 'Start Puppet Master':
#    ensure => running,
#    enable => true,
#  }
  
  exec { 'Start Masters':
    path      =>  "/usr/bin/puppet",
    cwd       =>  "/usr/bin/",
    command   =>  "/usr/bin/puppet master",
    require   =>  [Host['agent.vm'],Host['agentweb.vm'], File["Set puppet ownership"]]
  }
  
}
include master_agent
