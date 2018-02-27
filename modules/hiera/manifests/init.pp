# Class: hiera
#
# This module manages hiera
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class hiera {
  $puppet_file_dir    = "modules/${module_name}/"
  $puppet_home        = "/etc/puppet/"
  $puppet_conf_home   = "/etc/puppetlabs/code/"
  $hiera_conf         = "hiera.yaml"
  $hiera_data         = "hieradata/"
  $hiera_common       = "common.yaml"

  notify {"Puppet file directory ${puppet_file_dir}":}

  file {["/etc/puppetlabs/","${puppet_conf_home}"]:
    ensure => directory,
  }

  file {
    "${hiera_conf}":
   require    =>  File["${puppet_conf_home}"],
    path       =>  "${puppet_conf_home}${hiera_conf}",
    ensure     =>  present,
    source     =>  ["puppet:///${puppet_file_dir}${hiera_conf}"],
  }

  file {
    "${hiera_data}":
    path      =>  "${puppet_home}${hiera_data}",
    ensure    =>  directory,
    mode      =>  "0777",
    require   =>  File["${hiera_conf}"],
  }
  
  file {
    "${hiera_common}":
    path      =>  "${puppet_home}${hiera_data}${hiera_common}",
    ensure    =>  present,
    source    =>  ["puppet:///${puppet_file_dir}${hiera_common}"],
    require   =>  File["${hiera_data}"],
  }
}
