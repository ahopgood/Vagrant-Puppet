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

  notify {"Puppet file directory ${puppet_file_dir}":}
  
  file {
    "${hiera_conf}":
#    require    =>  File["${local_install_dir}"],
    path       =>  "${puppet_home}${hiera_conf}",
    ensure     =>  present,
    source     =>  ["puppet:///${puppet_file_dir}${hiera_conf}"],
  }

  file {
    "${hiera_data}":
    path      =>  "${puppet_home}${hiera_data}",
    ensure    =>  directory,
    mode      =>  0777,
    require   =>  File["${hiera_conf}"],
  }
  
  file {
    "${hiera_common}":
    path      =>  "${puppet_home}${hiera_data}${hiera_common}",
    ensure    =>  present,
    source    =>  ["puppet:///${puppet_file_dir}${hiera_common}"],
    require   =>  File["${hiera_data}"],
  }
  
/*
  exec {
    "Setup hiera file":
    command   =>  "ln -s /vagrant/hiera/hiera.yaml /etc/puppet/hiera.yaml",
    path      =>  '/bin/',
    cwd       =>  '/bin/',
    onlyif    =>  "echo 1",
#    onlyif    =>  "ls -l /etc/puppet | grep -c hiera.yaml",
    before    =>  Exec['Setup hiera data folder']
  }
 */
/*  
  exec {
    "Setup hiera data folder":
    command   =>  "mkdir /etc/puppet/hieradata",
    path      =>  '/bin/',
    cwd       =>  '/bin/',
    before    =>  Exec['Setup hiera common file'],
#    onlyif    =>  "mkdir /etc/puppet/hieradata",
    onlyif    =>  "ls -l /etc/puppet | grep -c hieradata",
  }
   */
   
   /*
  exec {
    "Setup hiera common file":
    command   =>  "ln -s /vagrant/hiera/common.yaml /etc/puppet/hieradata/common.yaml",
    path      =>  '/bin/',
    cwd       =>  '/bin/',
#    onlyif    =>  "ln -s /vagrant/hiera/common.yaml /etc/puppet/hieradata/common.yaml",
    onlyif    =>  "ls -l /etc/puppet/hieradata EEEEEEEEEa nk,,mmm| grep -c common.yaml",
  }
  */
}
