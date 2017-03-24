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
  notify { "In ${OS} ${OS_version}": }

  if (versioncmp("${OS}","Ubuntu") == 0){
    #    ddclient::ubuntu{"":}
    #    contain ddclient::ubuntu

    $ddclient_file = "ddclient_${major_version}.${minor_version}.${patch_version}-1.1ubuntu1_all.deb"
    $provider = "dpkg"


  } elsif (versioncmp("${OS}","CentOS") == 0){
    if (versioncmp("${OS_version}", "7") == 0) {
      $perl_libs_package="5.16.3-291.el7"
      $perl_digest_package="2.13-9.el7"
      $perl_Time_HiRes_package="1.9725-3.el7"
      $perl_package="5.16.3-291.el7"
      $perl_Net_LibIDN_package = "0.12-15.el7"
      $perl_Net_SSLeay_package = "1.55-4.el7"
      $perl_IO_Socket_SSL_package="1.94-5.el7"
      $ddclient_file = "ddclient-${major_version}.${minor_version}.${patch_version}-2.el7.noarch.rpm"
    } elsif (versioncmp("${OS_version}", "6") == 0) {
      $perl_libs_package="5.10.1-141.el6_7.1"
      $perl_digest_package="2.12-2.el6"
      $perl_Time_HiRes_package="1.9721-141.el6_7.1"
      $perl_package="5.10.1-141.el6_7.1"
      $perl_Net_LibIDN_package="0.12-3.el6"
      $perl_Net_SSLeay_package = "1.35-10.el6_8.1"
      $perl_IO_Socket_SSL_package="1.31-3.el6_8.2"
      $ddclient_file = "ddclient-${major_version}.${minor_version}.${patch_version}-1.el6.noarch.rpm"
    }
    $perl_libs="perl-libs-${perl_libs_package}.x86_64.rpm"
    $perl_digest="perl-Digest-SHA1-${perl_digest_package}.x86_64.rpm"
    $perl_Time_HiRes="perl-Time-HiRes-${perl_Time_HiRes_package}.x86_64.rpm"
    $perl="perl-${perl_package}.x86_64.rpm"
    $perl_Net_LibIDN = "perl-Net-LibIDN-${perl_Net_LibIDN_package}.x86_64.rpm"
    $perl_Net_SSLeay = "perl-Net-SSLeay-${perl_Net_SSLeay_package}.x86_64.rpm"
    $perl_IO_Socket_SSL="perl-IO-Socket-SSL-${perl_IO_Socket_SSL_package}.noarch.rpm"

    $provider = "rpm"

    file { "${perl_libs}":
      ensure => present,
      source => "puppet:///${puppet_file_dir}${OS}/${OS_version}/${perl_libs}",
      path   => "${local_install_dir}/${perl_libs}",
    }

    file { "${perl_Time_HiRes}":
      ensure => present,
      source => "puppet:///${puppet_file_dir}${OS}/${OS_version}/${perl_Time_HiRes}",
      path   => "${local_install_dir}/${perl_Time_HiRes}",
    }

    file { "${perl}":
      ensure => present,
      source => "puppet:///${puppet_file_dir}${OS}/${OS_version}/${perl}",
      path   => "${local_install_dir}/${perl}",
    }

    package { ["perl","perl-libs","perl-Time-HiRes"]:
      source          => ["${local_install_dir}/${perl}","${local_install_dir}/${perl_libs}","${local_install_dir}/${perl_Time_HiRes}"],
      ensure          => ["${perl_package}","${perl_libs_package}","${perl_Time_HiRes_package}"],
      provider        => "${provider}",
      require         => [File["${perl}"],File["${perl_libs}"], File["${perl_Time_HiRes}"]],
      install_options => "--force",
      before          => Package["ddclient"]
    }


    file { "${perl_digest}":
      ensure => present,
      source => "puppet:///${puppet_file_dir}${OS}/${OS_version}/${perl_digest}",
      path   => "${local_install_dir}/${perl_digest}",
    }


    package { "perl-Digest-SHA1":
      source   => "${local_install_dir}/${perl_digest}",
      ensure   => "${perl_digest_package}",
      provider => "${provider}",
      require  => File["${perl_digest}"],
      before   => Package["ddclient"],
    }

    #Requires:
    #perl(IO::Socket::IP) >= 0.20 is needed by perl-IO-Socket-SSL-1.94-5.el7.noarch
    #   provider: perl-IO-Socket-IP.noarch 0.21-4.el7
#CentOS 7 only
    if (versioncmp("${OS}${OS_version}","CentOS7") == 0){
      $perl_IO_Socket_IP = "perl-IO-Socket-IP-0.21-4.el7.noarch.rpm"
      file { "${perl_IO_Socket_IP}":
        ensure => present,
        path   => "${local_install_dir}/${perl_IO_Socket_IP}",
        source => "puppet:///${puppet_file_dir}${OS}/${OS_version}/${perl_IO_Socket_IP}",
      }

      package { "perl-IO-Socket-IP":
        ensure   => "0.21-4.el7",
        provider => "${provider}",
        source   => "${local_install_dir}/${perl_IO_Socket_IP}",
        require  => File["${perl_IO_Socket_IP}"],
        before => Package["perl-IO-Socket-SSL"],
      }
    }

    #perl(Net::LibIDN) is needed by perl-IO-Socket-SSL-1.94-5.el7.noarch
    #   provider: perl-Net-LibIDN.x86_64 0.12-15.el7
    file { "${perl_Net_LibIDN}":
      ensure => present,
      path   => "${local_install_dir}/${perl_Net_LibIDN}",
      source => "puppet:///${puppet_file_dir}${OS}/${OS_version}/${perl_Net_LibIDN}",
    }
    package{ "perl-Net-LibIDN":
      ensure   => "${perl_Net_LibIDN_package}",
      provider => "${provider}",
      source   => "${local_install_dir}/${perl_Net_LibIDN}",
      require  => File["${perl_Net_LibIDN}"]
    }

    #perl(Net::SSLeay) is needed by perl-IO-Socket-SSL-1.94-5.el7.noarch
    #perl(Net::SSLeay) >= 1.21 is needed by perl-IO-Socket-SSL-1.94-5.el7.noarch
    #    provider: perl-Net-SSLeay.x86_64 1.55-3.el7
    file { "${perl_Net_SSLeay}":
      ensure => present,
      path   => "${local_install_dir}/${perl_Net_SSLeay}",
      source => "puppet:///${puppet_file_dir}${OS}/${OS_version}/${perl_Net_SSLeay}",
    }
    package{ "perl-Net-SSLeay":
      ensure   => "${perl_Net_SSLeay_package}",
      provider => "${provider}",
      source   => "${local_install_dir}/${perl_Net_SSLeay}",
      require  => File["${perl_Net_SSLeay}"],
    }

    file { "${perl_IO_Socket_SSL}":
      ensure => present,
      source => "puppet:///${puppet_file_dir}${OS}/${OS_version}/${perl_IO_Socket_SSL}",
      path   => "${local_install_dir}/${perl_IO_Socket_SSL}",
    }

    package { "perl-IO-Socket-SSL":
      source          => "${local_install_dir}/${perl_IO_Socket_SSL}",
      ensure          => "${perl_IO_Socket_SSL_package}",
      provider        => "${provider}",
      require         => [File["${perl_IO_Socket_SSL}"], Package["perl-Net-LibIDN"], Package["perl-Net-SSLeay"] ],
      before          => Package["ddclient"],
    }
  }#end CentOS check

  file{ "${ddclient_file}":
    ensure => present,
    path   => "${local_install_dir}/${ddclient_file}",
    source => "puppet:///${puppet_file_dir}${OS}/${OS_version}/${ddclient_file}",
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
     or (versioncmp("${operatingsystem}${operatingsystemmajrelease}","Ubuntu15.10") == 0)){
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