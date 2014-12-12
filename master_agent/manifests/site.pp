#This module manages the node configuration 

import 'nodes.pp'
class master_agent {

#  service { "iptables":
#    enable  =>  false,
#    ensure  => stopped,
#  }
}  
include master_agent

