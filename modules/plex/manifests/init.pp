# Class: plex
#
# This module manages plex
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class plex {

  #Run dpkg -i plexmediaserver.ver.hash_amd64.deb
  #Use fiddler to watch for API calls then replicate these using cURL
  #Sign in with account details
  #Setup Tv libraries
  #Setup Movie libraries
  #Setup Music libraries

  #Example plex installer name: plexmediaserver_1.0.3.2461-35f0caa_amd64
  $major_version  = "1"
  $minor_version  = "0"
  $patch_version  = "3"
  $build_hash     = "2461-35f0caa"
  $arch           = "amd64"

#  $local_install_path = "/etc/puppet/"
#  $local_install_dir = "${local_install_path}installers/"
  $puppet_file_dir = "modules/${module_name}/"

#  file {
#    "${local_install_dir}":
#    path       =>  "${local_install_dir}",
#    ensure     =>  directory,
#  } 
  
  $plex_name      = "plexmediaserver_${major_version}.${minor_version}.${patch_version}.${build_hash}_${arch}.deb"

  $test_file = "Game.of.Thrones.S03E03.HDTV.x264-EVOLVE.mp4"

  if $::operatingsystem == 'ubuntu' {
    notify {    "Using operating system:$::operatingsystem": }
  } else {
    notify {  "Operating system not supported:$::operatingsystem":  }  
  }

  file {
    "${local_install_dir}/${plex_name}":
    ensure => present,
    source => "puppet:///${puppet_file_dir}${plex_name}",
    path => "${local_install_dir}/${plex_name}"
  }
  
  file {
    "testfile":
    ensure => present,
    source => "puppet:///${puppet_file_dir}${test_file}",
    path => "${local_install_dir}/${test_file}"
  }

  exec {"plexmediaserver":
#    ensure => present,
#    provider => 'apt',
    path => "/usr/bin/",
    command => "dpkg -i ${local_install_dir}/${plex_name}",
    require => File["${local_install_dir}/${plex_name}"],
  }  
}
