# Class: httpd
#
# This module manages httpd.
# Note that there are folder hierarchy dependencies on /etc/puppt/installers.
# Also requires port 80 to be open or else navigating to the ip address will fail, if open you will see the apache welcome page.
# Use of the iptables class is recommended.
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class httpd {

  $puppet_file_dir = "modules/httpd/"
  $local_install_dir = "${local_install_path}installers/"

  $httpd_user = "apache"
  $httpd_group = "apache"

  $os = "$operatingsystem$operatingsystemmajrelease"  
  group { "${httpd_group}":
    ensure    =>  present,
  }

  user { "${httpd_user}":
    ensure      =>  present,
    home        =>  "/home/${httpd_user}",
    managehome  =>  true,
    shell       =>  '/bin/bash',
    groups      =>  ["${httpd_group}"],
    require     =>  Group["${httpd_group}"]
  }

  if ("${operatingsystem}" == "CentOS") {
    class{"httpd::centos":
      httpd_user => $httpd_user,
      httpd_group => $httpd_group,
    }
    contain 'httpd::centos'
  } elsif ("${operatingsystem}" == "Ubuntu") {
    if (versioncmp("${operatingsystemmajrelease}", "18.04") == 0) {
      httpd::ubuntu::bionic{"bionic":}
    } else {
      notify{"Using ${operatingsystem}":}
      $patch_version = "${operatingsystem}${operatingsystemmajrelease}" ? {
        "Ubuntu15.10" => "12",
        "Ubuntu16.04" => "39",
      }
      class{"httpd::ubuntu":
        major_version => "2",
        minor_version => "4",
        patch_version => "${patch_version}"
      }
      contain "httpd::ubuntu"
    }
  } else {
    notify{"${operatingsystem} version ${operatingsystemmajrelease}":}
  }
}