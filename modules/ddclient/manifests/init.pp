# Class: ddclient
#
# This module manages ddclient
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class ddclient{

  $local_install_dir    = "${local_install_path}installers"
  $puppet_file_dir      = "modules/ddclient/"

  $major_version        = "3"
  $minor_version        = "8"
  $patch_version        = "3"
  
  $OS = $operatingsystem
  $OS_version = $operatingsystemmajrelease
  notify {"In ${OS} ${OS_version}":}
  
  if (versioncmp("${OS}","Ubuntu") == 0){
#    ddclient::ubuntu{"":}
#    contain ddclient::ubuntu

    $ddclient_file = "ddclient_${major_version}.${minor_version}.${patch_version}-1.1ubuntu1_all.deb"
    file{"${ddclient_file}":
      ensure => present,
      path => "${local_install_dir}/${ddclient_file}",
      source => "puppet:///${puppet_file_dir}${OS}/${OS_version}/${ddclient_file}",
    }
    
    package {"ddclient":
      ensure => present,
      provider => "dpkg",
      source => "${local_install_dir}/${ddclient_file}",
      require => File["${ddclient_file}"],
    }
    
    service {"ddclient":
      ensure => running,
      enable => true, 
      require => Package["ddclient"]
    }

    $entries = [
    "set protocol namecheap",
    "set use web, web=dynamicdns.park-your-domain.com/getip",
    "set ssl yes",
    "set server dynamicdns.park-your-domain.com",
    "set login katherinemorley.net", 
    "set password 'e8089f5428474eb29261337c54715f9d' @.katherinemorley.net,www.katherinemorley.net",
    ]
    
#    augeas{ "add-entry":
#      incl => "/etc/ddclient.conf",
#      lens => "Simplevars.lns",
#      context => "/files/etc/ddclient.conf/",
#      changes => $entries,
#    }
#    set /augeas/load/Simplevars/lens/ Simplevars.lns
#    set /augeas/load/Simplevars/incl/ /etc/ddclient.conf
    #  protocol=namecheap
#  use=web, web=dynamicdns.park-your-domain.com/getip
#  ssl=yes
#  server=dynamicdns.park-your-domain.com
#  login=katherinemorley.net, password='e8089f5428474eb29261337c54715f9d' \
#  @.katherinemorley.net,www.katherinemorley.net

    # Install lens file, where?
    # Load lens
  } #end Ubuntu 15 check
}