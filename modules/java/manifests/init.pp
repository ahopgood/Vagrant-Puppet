# Class: java
#
# This module manages java.
# Supported Java 6,7 & 8
# Upgrades from 6 to 7 and back are accounted for by the package manager.
# Upgrades to 8 from 6 or 7 will see the older jdk's uninstalled, downgrades will see Java 8 persist and the Java 6 or 7 installed as well. 
#
# Parameters: 
# isJdk; if true then attempts to install the jdk, otherwise installs a jre, defaults to true. 
# version; which indicates the version of java to install, defaults to 6.45
# 64bit; if true then a 64-bit version is installed, by default selects 64-bt
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
define java (
#	$is64bit = true, 
	#$isJdk = true,
	$version = "6",
	$updateVersion = "45") {
	
  $local_install_path = "/etc/puppet/"
  $local_install_dir  = "${local_install_path}installers${version}/"
  $puppet_file_dir    = "modules/java/"
  
  #Check file exists either in the puppet file server or locally in a vagrant shared folder   
  $is64bit = true
  #package names are a pain
  #puppet resource package | grep -A10 packagename
  #Will help to identify the title and ensures values of a package
  #rpm -qa jdk
  #Will help to identify the names as far as rpm sees them
  notify{"Java version from hiera ${version}":}
  
    #Setup already in fileserver
#  file {
#    "${local_install_dir}":
#    path       =>  "${local_install_dir}",
#    ensure     =>  directory,
#  }


  
  #Perform actions appropriate to the OS
  if $::operatingsystem == 'CentOS' {
    class {"java::centos":
      version => $version,
      updateVersion => $updateVersion,
      is64bit => $is64bit
    }
  } elsif $::operatingsystem == "Ubuntu"{
       include java::ubuntu::wily
     java::ubuntu{"test-java-${version}":
      version => $version,
      updateVersion => $updateVersion,
      is64bit => $is64bit
    }
  } else {
    notify {  "Operating system not supported:$::operatingsystem$::operatingsystemmajrelease":  }  
  }
  
  #  subscribe   =>  Package['java-sdk'],
  #  require     =>  Package['java-sdk'],
}


