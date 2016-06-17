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

  $puppet_file_dir = "modules/iptables/"
  $local_install_dir = "${local_install_path}installers/"
  #if centos 7
  #sudo systemctl disable firewalld

  #sudo yum install iptables-services
  #or download the rpm and install manually
  #systemctl enable iptables

  $os = "$operatingsystem$operatingsystemmajrelease"
  if "${os}" == "CentOS7"{
    notify {"We have CentOS7": }
    
    exec {"save iptables":
      path => "/usr/sbin/",
      command => "iptables-save > /vagrant/files/backup/iptables-save.bak"
    }
    
    exec {"Stop firewalld":
      path => "/usr/bin/",
      command => "systemctl stop firewalld",
    }

    exec {"Disable firewalld":
      path => "/usr/bin/",
      command => "systemctl disable firewalld",
      require => Exec["Stop firewalld"]
    }
    
    $iptables = "iptables-1.4.21-16.el7.x86_64.rpm"
    file {
      "${iptables}":
      ensure  => present,
      path    => "${local_install_dir}${iptables}",
      source  => ["puppet:///${puppet_file_dir}${iptables}"],
    }
    exec {"iptables":
      path => "/bin/",
      command => "rpm -Uvh ${local_install_dir}${iptables}",
      require => [File["${iptables}"],Exec["save iptables"]],
    }
    
    exec {"restore iptables config":
      path => "/usr/sbin/",
      command => "iptables-restore < /vagrant/files/backup/iptables-save.bak",
      require => Exec["iptables"]
    }
          
    $iptables_services = "iptables-services-1.4.21-16.el7.x86_64.rpm"
    file {
      "${iptables_services}":
      ensure => present,
      path => "${local_install_dir}${iptables_services}",
      source => ["puppet:///${puppet_file_dir}${iptables_services}"],
    }
    package {"iptables-services":
      ensure => present,
      provider => "rpm",
      source => "${local_install_dir}${iptables_services}",
      require => [File["${iptables_services}"],Exec["iptables"]],
    }
    
    exec {"Enable iptables as a service":
      path => "/bin/",
      command => "systemctl enable iptables",
      before => [Exec["add-port-exception"], Service["iptables"]],
      require => Package["iptables-services"]
    }

#    exec {"Enable start iptables as a service":
#      path => "/bin/",
#      command => "systemctl start iptables",
#      before => [Exec["add-port-exception"]],#,Service["iptables"]],
#      require => Package["iptables-services"]
#    }

  }
  
#  
  #can we pass in an array of ports?
  #should we differentiate between tcp and udp ports?
  #should we be able to add an insert position for rules?
  #need to stop the rule applying if it already exists?  
  if ("${isTCP}"){
    $protocol = "tcp"
  } else {
    $protocol = "udp"
  }
  
  $iptableInputLevel = "INPUT 1 "
  $iptableRule = "-p ${protocol} -m state --state NEW --dport ${port} -j ACCEPT" 
 
  notify {"Found protocol ${protocol} and port ${port}":}
    
  exec { "add-port-exception":
    path    =>  "/sbin/",
    command   =>  "iptables -I ${iptableInputLevel}${iptableRule}",
    #No proof the onlyif bit works
    #onlyif => "iptables --list-rules | /bin/grep -- ${port}", #check the rule doesn't already exist
    unless => "iptables --list-rules | /bin/grep -- ${port}", #check the rule doesn't already exist
  }
  
  exec { "save-ports":
    path    =>  "/sbin/",
    command   => "service iptables save",
    notify    =>  Service["iptables"],
    require   => Exec["add-port-exception"]
  }
  
  service { "iptables":
    enable  =>  true,
    ensure  => running,
  } 
}
