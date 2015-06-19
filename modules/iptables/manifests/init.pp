# Class: iptables
#
# This module manages iptables
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class iptables (
  $port = "",
  $isTCP = true
) {

  #can we pass in an array of ports?
  #should we differentiate between tcp and udp ports?
  #should we be able to add an insert position for rules?
  #need to stop the rule applying if it already exists?
  if ("${isTCP}"){
    $protocol = "tcp"
  } else {
    $protocol = "udp"
  }
  
  service { "iptables":
      enable  =>  true,
      ensure  => running,
  }  
 
  notify {"Found protocol ${protocol}":}
 
  exec { "add-tcp-port-exception":
    path    =>  "/sbin/",
    command   =>  "iptables -I INPUT 1 -m state --state NEW -p ${protocol} --dport ${port} -j ACCEPT",
  }
  
  exec { "save-ports":
    path    =>  "/sbin/",
    command   => "service iptables save",
    notify    =>  Service["iptables"],
    require   => Exec["add-tcp-port-exception"]
  }
}
