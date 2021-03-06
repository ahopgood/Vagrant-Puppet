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
  $hiera_conf         = "hiera.yaml"
  $hiera_data         = "hieradata/"
  $hiera_common       = "common.yaml"
  $hiera_osfamily_debian = "Debian.yaml"
  $hiera_osfamily_dir = "osfamily/"

  notify {"Puppet file directory ${puppet_file_dir}":}

  if (versioncmp("${clientversion}", "5.0.0") == "-1") {
    notify{"We're on an old version of puppet [${clientversion}], we will use hiera 3 syntax":}
    $versioned_location = "puppet/4/"
  } else {
    notify{"We're on puppet version greater than 5.0.0 [${clientversion}], we will use hiera 5 syntax":}
    $versioned_location = "puppet/5/"
  }

  file {
    "${hiera_conf}":
    # require    =>  File["${puppet_home}"],
    path       =>  "${puppet_home}${hiera_conf}",
    ensure     =>  present,
    source     =>  ["puppet:///${puppet_file_dir}${versioned_location}${hiera_conf}"],
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

  file { "${puppet_home}${hiera_data}${hiera_osfamily_dir}":
    ensure => directory,
  }

  file {
    "${hiera_osfamily_debian}":
      path      =>  "${puppet_home}${hiera_data}${hiera_osfamily_dir}${hiera_osfamily_debian}",
      ensure    =>  present,
      source    =>  ["puppet:///${puppet_file_dir}${operatingsystem}/${hiera_osfamily_debian}"],
      require   =>  File["${hiera_data}"],
  }
}

define hiera::add_hierarchy {

}