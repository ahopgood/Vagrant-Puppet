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

  $os = $operatingsystem
  $os_version = $operatingsystemmajrelease
  notify { "In ${os} ${os_version}": }

  if (versioncmp("${os}","Ubuntu") == 0){
    $ddclient_file = "ddclient_${major_version}.${minor_version}.${patch_version}-1.1ubuntu1_all.deb"
    $provider = "dpkg"
  } elsif (versioncmp("${os}","CentOS") == 0){
    if (versioncmp("${os_version}", "7") == 0) {
      $ddclient_file = "ddclient-${major_version}.${minor_version}.${patch_version}-2.el7.noarch.rpm"
    } elsif (versioncmp("${os_version}", "6") == 0) {
      $ddclient_file = "ddclient-${major_version}.${minor_version}.${patch_version}-1.el6.noarch.rpm"
    }
    $provider = "rpm"
    Class["perl"]
    ->
    Package["ddclient"]
    
    class{"perl":
      before => Package["ddclient"]
    }
  }#end CentOS check

  file{ "${ddclient_file}":
    ensure => present,
    path   => "${local_install_dir}/${ddclient_file}",
    source => "puppet:///${puppet_file_dir}${os}/${os_version}/${ddclient_file}",
  }

  package { "ddclient":
    ensure   => present,
    provider => "${provider}",
    source   => "${local_install_dir}/${ddclient_file}",
    require  => File["${ddclient_file}"],
  }

  service { "ddclient":
    ensure  => running,
    enable  => true,
    require => Package["ddclient"]
  }

  file { "/usr/share/augeas/lenses/dist/ddclientconf.aug":
    ensure => "present",
    source => "puppet:///${puppet_file_dir}DDClientConf.lns",
    mode   => 0777,
    #    require => [Service["ddclient"]],
  }

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
}

define ddclient::entry(
  $protocol = undef,
  $use = undef,
  $ssl = undef,
  $server = undef,
  $login = undef,
  $password = undef,
  $domains = undef,
  $remove_package_conf = false,
){


  if ((versioncmp("${operatingsystem}${operatingsystemmajrelease}","CentOS6") == 0)
     or (versioncmp("${operatingsystem}${operatingsystemmajrelease}","Ubuntu15.10") == 0)
      or (versioncmp("${operatingsystem}${operatingsystemmajrelease}","Ubuntu16.04") == 0)){
    $ls_path = "/bin/"
    $rm_path = "/bin/"
  } else {
    $ls_path = "/usr/bin/"
    $rm_path = "/usr/bin/"
  }

  if ($remove_package_conf == true){
    exec {"remove ddclient.conf ${name}":
      path => "${rm_path}",
      command => "rm /etc/ddclient.conf",
      require => [File["/usr/share/augeas/lenses/dist/ddclientconf.aug"]],
      onlyif => "${ls_path}ls /etc/ | /bin/grep ddclient"
    }

    file {"/etc/ddclient.conf  ${name}":
      path => "/etc/ddclient.conf",
      ensure => present,
      mode => 0777,
      require => [Exec["remove ddclient.conf ${name}"]],
      before => Augeas["add-entry ${name}"]
    }

  }
  if ($protocol == undef){
    fail("A protocol is required to setup a ddclient entry")
  }

  if ($use == undef){
    fail("A use is required to setup a ddclient entry")
  }

  if ($ssl == undef){
    fail("An ssl value is required to setup a ddclient entry")
  }

  if ($server == undef){
    fail("A server value is required to setup a ddclient entry")
  }

  if ($login == undef){
    fail("A login value is required to setup a ddclient entry")
  }

  if ($password == undef){
    fail("A password value is required to setup a ddclient entry")
  }

  if ($domains == undef){
    fail("A list of domains is required to setup a ddclient entry")
  }

  #Entry needs to be added after service is installed
  #Then restart the service after the entry has been added to the ddclient.conf file.
  #Need to add more granular error reporting for puppet

  $entries = [
    "set entry[last()+1]/protocol ${protocol}",
    "set entry[last()]/use \"${use}\"",
    "set entry[last()]/ssl ${ssl}",
    "set entry[last()]/server ${server}",
    "set entry[last()]/login ${login}",
    "set entry[last()]/password \"'${password}'",
    "set entry[last()]/domain ${domains}",
  ]

  augeas{ "add-entry ${name}":
    incl => "/etc/ddclient.conf",
    lens => "Ddclientconf.lns",
    context => "/files/etc/ddclient.conf/",
    changes => $entries,
    require => [
      Service["ddclient"],
      File["/usr/share/augeas/lenses/dist/ddclientconf.aug"]],
#    notify => Service["ddclient"],
  }
}