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
  $puppet_file_dir      = "modules/${module_name}/"
  $puppetmaster         = "puppetmaster"
  $puppet_conf          = "puppet.conf"
  $vagrant_user         = "vagrant"
  

  service { "iptables":
    enable  =>  false,
    ensure  => stopped,
  }
  
  host { "agent.vm":
    ip            =>  "192.168.33.13",
  }
/*
  host { "agentweb.vm":
    ip            =>  "192.168.33.12",
  }
  */
  file {  "Set puppet ownership":
    path      =>  "/usr/bin/puppet",
    owner     =>  "vagrant",
    group     =>  "vagrant",
  }
  #Need to add the following to the puppet.conf file:
  #[master]
  #autosign true
  file {  "/etc/puppet/${puppet_conf}":
    ensure  =>  present,
    mode    =>  777,
    owner   =>  "${vagrant_user}",
    source  =>  ["/tmp/vagrant-puppet-3/files/files/${puppet_conf}", 
      "puppet://${puppet_file_dir}/${puppet_conf}"]
  }
  
  #Startup script for the puppet master service
  file { "${puppetmaster}" :
    path    =>  "/etc/init.d/${puppetmaster}",
    ensure  =>  present,
    mode    =>  0777,
    owner   =>  "${vagrant_user}",
    source  =>  ["/tmp/vagrant-puppet-3/files/files/${puppetmaster}",
      "puppet://${puppet_file_dir}/${puppetmaster}"],
    notify  =>  Service["${puppetmaster}"],
    require =>  File["/etc/puppet/${puppet_conf}"]
  } 
  
  service { "${puppetmaster}" :
    ensure  => running,
    enable  => true,
    require => File["${puppetmaster}"]
  }
  #Perform service start if: ps aux | grep puppet | grep -v grep
  
  #Need to 
  
#  exec { 'Start Masters':
#    path      =>  "/usr/bin/puppet",
#    cwd       =>  "/usr/bin/",
#    command   =>  "/usr/bin/puppet master",
#    require   =>  [Host['agent.vm'],Host['agentweb.vm'], File["Set puppet ownership"]]
#  }
  
}
include master_agent
