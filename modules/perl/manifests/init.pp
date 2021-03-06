# Class: perl
#
# This module manages perl
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class perl (

) {
  notify{ "perl Module running": }

  $os = "${operatingsystem}"
  $os_version = "${operatingsystemmajrelease}"
  
  $puppet_file_dir = "modules/perl/"
  $local_install_dir = "${local_install_path}installers/"

  if (versioncmp("${os}","CentOS") == 0){
    if (versioncmp("${os_version}", "7") == 0) {
      $perl_libs_package="5.16.3-291.el7"
      $perl_digest_package="2.13-9.el7"
      $perl_Time_HiRes_package="1.9725-3.el7"
      $perl_package="5.16.3-291.el7"
      $perl_Net_LibIDN_package = "0.12-15.el7"
      $perl_Net_SSLeay_package = "1.55-4.el7"
      $perl_IO_Socket_SSL_package="1.94-5.el7"

    } elsif (versioncmp("${os_version}", "6") == 0) {
      $perl_libs_package="5.10.1-141.el6_7.1"
      $perl_digest_package="2.12-2.el6"
      $perl_Time_HiRes_package="1.9721-141.el6_7.1"
      $perl_package="5.10.1-141.el6_7.1"
      $perl_Net_LibIDN_package="0.12-3.el6"
      $perl_Net_SSLeay_package = "1.35-10.el6_8.1"
      $perl_IO_Socket_SSL_package="1.31-3.el6_8.2"

      $perl_Module_Pluggable_package="3.90-141.el6_7.1"
      $perl_Module_Pluggable="perl-Module-Pluggable-${perl_Module_Pluggable_package}.x86_64.rpm"
      
      $perl_Pod_Escapes_package="1.04-141.el6_7.1"
      $perl_Pod_Escapes="perl-Pod-Escapes-${perl_Pod_Escapes_package}.x86_64.rpm"

      $perl_Pod_Simple_package="3.13-141.el6_7.1"
      $perl_Pod_Simple="perl-Pod-Simple-${perl_Pod_Simple_package}.x86_64.rpm"
      
      $perl_version_package="0.77-141.el6_7.1"
      $perl_version="perl-version-${perl_version_package}.x86_64.rpm"

      file {"${perl_version}":
        ensure => present,
        source => "puppet:///${puppet_file_dir}${os}/${os_version}/${perl_version}",
        path   => "${local_install_dir}/${perl_version}",
        before => Package["perl"]
      }
      file { "${perl_Pod_Escapes}":
        ensure => present,
        source => "puppet:///${puppet_file_dir}${os}/${os_version}/${perl_Pod_Escapes}",
        path   => "${local_install_dir}/${perl_Pod_Escapes}",
        before => Package["perl"]
      }

      file { "${perl_Module_Pluggable}":
        ensure => present,
        source => "puppet:///${puppet_file_dir}${os}/${os_version}/${perl_Module_Pluggable}",
        path   => "${local_install_dir}/${perl_Module_Pluggable}",
        before => Package["perl"]
      }


      file { "${perl_Pod_Simple}":
        ensure => present,
        source => "puppet:///${puppet_file_dir}${os}/${os_version}/${perl_Pod_Simple}",
        path   => "${local_install_dir}/${perl_Pod_Simple}",
        before => Package["perl"]
      }
    }
    $perl_libs="perl-libs-${perl_libs_package}.x86_64.rpm"
    $perl_digest="perl-Digest-SHA1-${perl_digest_package}.x86_64.rpm"
    $perl_Time_HiRes="perl-Time-HiRes-${perl_Time_HiRes_package}.x86_64.rpm"
    $perl="perl-${perl_package}.x86_64.rpm"
    $perl_Net_LibIDN = "perl-Net-LibIDN-${perl_Net_LibIDN_package}.x86_64.rpm"
    $perl_Net_SSLeay = "perl-Net-SSLeay-${perl_Net_SSLeay_package}.x86_64.rpm"
    $perl_IO_Socket_SSL="perl-IO-Socket-SSL-${perl_IO_Socket_SSL_package}.noarch.rpm"

    if (versioncmp("${os}","Centos") == 0){
      if (versioncmp("${os_version}", "7") == 0) {
        $perl_package_names=["perl","perl-libs","perl-Time-HiRes"]
        $perl_package_versions=["${perl_package}","${perl_libs_package}","${perl_Time_HiRes_package}"]
        $perl_package_files=["${local_install_dir}/${perl}","${local_install_dir}/${perl_libs}","${local_install_dir}/${perl_Time_HiRes}"]
      } elsif (versioncmp("${os_version}","6") == 0){
        $perl_package_names=["perl","perl-libs","perl-Time-HiRes",
          "perl-Module-Pluggable", "perl-Pod-Escapes", "perl-Pod-Simple", "perl-version"]

        $perl_package_versions=["${perl_package}","${perl_libs_package}","${perl_Time_HiRes_package}",
          "${perl_Pod_Escapes_package}", "${perl_version_package}", "${perl_Module_Pluggable_package}",
          "${perl_Pod_Simple_package}"]

        $perl_package_files=["${local_install_dir}/${perl}","${local_install_dir}/${perl_libs}",
          "${local_install_dir}/${perl_Time_HiRes}", "${local_install_dir}/${perl_Pod_Escapes}",
          "${local_install_dir}/${perl_version}", "${local_install_dir}/${perl_Module_Pluggable}",
          "${local_install_dir}/${perl_Pod_Simple}"]
      }
    }
    
    $provider = "rpm"

    file { "${perl_libs}":
      ensure => present,
      source => "puppet:///${puppet_file_dir}${os}/${os_version}/${perl_libs}",
      path   => "${local_install_dir}/${perl_libs}",
    }

    file { "${perl_Time_HiRes}":
      ensure => present,
      source => "puppet:///${puppet_file_dir}${os}/${os_version}/${perl_Time_HiRes}",
      path   => "${local_install_dir}/${perl_Time_HiRes}",
    }

    file { "${perl}":
      ensure => present,
      source => "puppet:///${puppet_file_dir}${os}/${os_version}/${perl}",
      path   => "${local_install_dir}/${perl}",
    }

    package { $perl_package_names:
      source          => $perl_package_files,
      ensure          => $perl_package_versions,
      provider        => "${provider}",
      require         => [File["${perl}"],File["${perl_libs}"], File["${perl_Time_HiRes}"]],
      install_options => "--force",
    }


    file { "${perl_digest}":
      ensure => present,
      source => "puppet:///${puppet_file_dir}${os}/${os_version}/${perl_digest}",
      path   => "${local_install_dir}/${perl_digest}",
    }


    package { "perl-Digest-SHA1":
      source   => "${local_install_dir}/${perl_digest}",
      ensure   => "${perl_digest_package}",
      provider => "${provider}",
      require  => File["${perl_digest}"],
    }

    #Requires:
    #perl(IO::Socket::IP) >= 0.20 is needed by perl-IO-Socket-SSL-1.94-5.el7.noarch
    #   provider: perl-IO-Socket-IP.noarch 0.21-4.el7
    #CentOS 7 only
    if (versioncmp("${os}${os_version}","CentOS7") == 0){
      $perl_IO_Socket_IP = "perl-IO-Socket-IP-0.21-4.el7.noarch.rpm"
      file { "${perl_IO_Socket_IP}":
        ensure => present,
        path   => "${local_install_dir}/${perl_IO_Socket_IP}",
        source => "puppet:///${puppet_file_dir}${os}/${os_version}/${perl_IO_Socket_IP}",
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
      source => "puppet:///${puppet_file_dir}${os}/${os_version}/${perl_Net_LibIDN}",
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
      source => "puppet:///${puppet_file_dir}${os}/${os_version}/${perl_Net_SSLeay}",
    }
    package{ "perl-Net-SSLeay":
      ensure   => "${perl_Net_SSLeay_package}",
      provider => "${provider}",
      source   => "${local_install_dir}/${perl_Net_SSLeay}",
      require  => File["${perl_Net_SSLeay}"],
    }

    file { "${perl_IO_Socket_SSL}":
      ensure => present,
      source => "puppet:///${puppet_file_dir}${os}/${os_version}/${perl_IO_Socket_SSL}",
      path   => "${local_install_dir}/${perl_IO_Socket_SSL}",
    }

    package { "perl-IO-Socket-SSL":
      source          => "${local_install_dir}/${perl_IO_Socket_SSL}",
      ensure          => "${perl_IO_Socket_SSL_package}",
      provider        => "${provider}",
      require         => [File["${perl_IO_Socket_SSL}"], Package["perl-Net-LibIDN"], Package["perl-Net-SSLeay"] ],
    }
  } else {
    fail ("${operatingsystem} ${operatingsystemmajrelease} is currently not supported for the perl module")
  }
}