# Class: agent
#
# This module manages agent
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class agent (
  $host_name="demo",
  $host_addr="127.0.0.1",
  $domain_name="localhost"){
    
  file {'/etc/hostname':
    ensure  =>  file,
    content =>  "${host_name}",
  }
  
  exec {  "Set hostname":
    path    =>  "/bin/",
    command =>  "hostname ${host_name}",
    require =>  File['/etc/hostname'],   
  }
}
