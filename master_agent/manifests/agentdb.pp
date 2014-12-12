class agentdb (
  $host_name="demo",
  $host_addr="127.0.0.1",
  $domain_name="localdomain"){

#  include mysql
  /*
  #Sets the hostname
  exec {  "Set hostname":
    path    =>  "/bin/",
    command =>  "hostname ${host_name}",   
  }
  #Hostname doesn't persist!
  #Persists the hostname so it applies after a shutdown/reboot
  file {'/etc/hostname':
    ensure  =>  file,
    content =>  "${host_name}",
  } 

  host { "${host_name}":
    ip            =>  "${host_addr}",
    host_aliases  =>  "${host_name}.${domain_name}",
  }
*/
/*    
  class { 'agent':
    host_name    => "demo",
    host_addr    =>  "127.0.0.1",
    domain_name  =>  "localhost"
  }
*/
/* 
  file {'/etc/hosts':
    ensure  =>  present,
  }->
  file_line {'Append to hostname file':
    path    =>  '/etc/hosts',
    line => "${host_addr} ${host_name} ${host_name}.${domain_name}",
    require =>  Exec['Set hostname'],
  }
  */
}
#include mater_agent::agent
include agentdb