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
    $provider = "dpkg"
  } elsif (versioncmp("${OS}","CentOS") == 0){
    $ddclient_file = "ddclient-${major_version}.${minor_version}.${patch_version}-2.el7.noarch.rpm"
    $provider = "rpm"

    exec { "perl-install":
#      command => "rpm -e perl perl-podlators ",
      command => "rpm -U /vagrant/files/CentOS/7/perl-5.16.3-291.el7.x86_64.rpm \ 
      /vagrant/files/CentOS/7/perl-libs-5.16.3-291.el7.x86_64.rpm \
      /vagrant/files/CentOS/7/perl-Time-HiRes-1.9725-3.el7.x86_64.rpm \ 
      /vagrant/files/CentOS/7/perl-IO-Socket-SSL-1.94-5.el7.noarch.rpm \
      /vagrant/files/CentOS/7/perl-Digest-SHA1-2.13-9.el7.x86_64.rpm",
      path    => "/usr/bin/",
#      before  => [Package["perl-libs"]]
    }
    
#    package {"perl-removal": 
##      name => "5.16.3-283.el7",
##      name => "perl.x86_64",
#      name => "perl",
#      ensure => absent,
#      before => [Package["perl-libs"]],
#      uninstall_options => ["--nodeps"]
#    }
    
    $perl_libs="perl-libs-5.16.3-291.el7.x86_64.rpm"
    file {"${perl_libs}":
      source => "puppet:///${puppet_file_dir}${OS}/${OS_version}/${perl_libs}",
      path => "${local_install_dir}/${perl_libs}",
    }

#    package {"perl-libs":
#      source => "${local_install_dir}/${perl_libs}",
#      ensure => "5.16.3-291.el7",
#      provider => "${provider}",
#      require => File["${perl_libs}"],
#      install_options => "--force",
#      before => [Package["ddclient"], Package["perl"]]
#    }

    $perl_Time_RiHes="perl-Time-HiRes-1.9725-3.el7.x86_64.rpm"
    file {"${perl_Time_RiHes}":
      source => "puppet:///${puppet_file_dir}${OS}/${OS_version}/${perl_Time_RiHes}",
      path => "${local_install_dir}/${perl_Time_RiHes}",
    }

#    package {"perl_Time_RiHes":
#      source => "${local_install_dir}/${perl_Time_RiHes}",
#      ensure => "1.9725-3.el7",
#      provider => "${provider}",
#      require => File["${perl_Time_RiHes}"],
#      install_options => "--force",
#      before => [Package["ddclient"], Package["perl"]]
#    }

    $perl="perl-5.16.3-291.el7.x86_64.rpm"
    file {"${perl}":
      source => "puppet:///${puppet_file_dir}${OS}/${OS_version}/${perl}",
      path => "${local_install_dir}/${perl}",
    }
    
#    package {"perl":
#      source => "${local_install_dir}/${perl}",
#      ensure => "5.16.3-291.el7",
##      ensure => installed,
#      provider => "${provider}",
#      require => File["${perl}"],
#      install_options => "--force",
#      before => Package["ddclient"]
#    }
    
    $perl_digest="perl-Digest-SHA1-2.13-9.el7.x86_64.rpm"
    file {"${perl_digest}":
      source => "puppet:///${puppet_file_dir}${OS}/${OS_version}/${perl_digest}",
      path => "${local_install_dir}/${perl_digest}",
    }

    
    $perl_IO_socket="perl-IO-Socket-SSL-1.94-5.el7.noarch.rpm"
    file {"${perl_IO_socket}":
      source => "puppet:///${puppet_file_dir}${OS}/${OS_version}/${perl_IO_socket}",
      path => "${local_install_dir}/${perl_IO_socket}",
    }
    
#    package {"perl":
#      source => "${local_install_dir}/${perl}",
#      ensure => "5.16.3-291.el7",
##      ensure => installed,
#      provider => "${provider}",
#      require => File["${perl}"],
#      install_options => "--force",
#      before => Package["ddclient"]
#    
  }
    file{"${ddclient_file}":
      ensure => present,
      path => "${local_install_dir}/${ddclient_file}",
      source => "puppet:///${puppet_file_dir}${OS}/${OS_version}/${ddclient_file}",
    }
    
    package {"ddclient":
      ensure => present,
      provider => "${provider}",
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
