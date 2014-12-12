class agent {
  #required to allow us to identify and communicate with the master node
    $host_name = "puppet"
    $host_addr = "192.168.33.10"

#  host { "${host_name}":
#    ip            =>  "${host_addr}",
  # host_aliases  =>  "${host_name}",
#  }
  #Set up the puppet conf to use the puppet master hostname
  
}
include agent