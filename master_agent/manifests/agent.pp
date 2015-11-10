class agent(
  $master_name = "puppet",
  $master_addr = "192.168.33.10") {
  #required to allow us to identify and communicate with the master node

  host { "${master_name}":
    ip            =>  "${master_addr}",
  }
  #Set up the puppet conf to use the puppet master hostname
  
  service { "iptables":
    enable  =>  false,
    ensure  => stopped,
  }
  
  
}
include agent