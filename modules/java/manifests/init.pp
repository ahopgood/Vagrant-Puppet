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
	$updateVersion = "45",
  $multiTenancy = false) {
	     
  $is64bit = true
  #package names are a pain
  #puppet resource package | grep -A10 packagename
  #Will help to identify the title and ensures values of a package
  #rpm -qa jdk
  #Will help to identify the names as far as rpm sees them
  notify{"Java version from hiera ${version}":}


  
  #Perform actions appropriate to the OS
  if $::operatingsystem == 'CentOS' {
    class {"java::centos":
      version => $version,
      updateVersion => $updateVersion,
      is64bit => $is64bit
    }
  } elsif $::operatingsystem == 'Ubuntu'{
       include java::ubuntu::wily
     java::ubuntu{"test-java-${version}":
      version => $version,
      updateVersion => $updateVersion,
      is64bit => $is64bit,
      multiTenancy => $multiTenancy
    }
  } else {
    notify {  "Operating system not supported:$::operatingsystem$::operatingsystemmajrelease":  }  
  }
  
  #  subscribe   =>  Package['java-sdk'],
  #  require     =>  Package['java-sdk'],
}

define alternatives::install(
  $executableName = undef,
  $executableLocation = undef,
){
  #Decide which alternatives program we have based on OS
  if $::operatingsystem == 'CentOS' {
    $alternativesName = "alternatives"
  } elsif $::operatingsystem == 'Ubuntu' {
    $alternativesName = "update-alternatives"
  } else {
    notify {"${::operatingsystem} is not supported":}
  }
  exec {
    "install-alternative-${executableName}":
    command     =>  "${alternativesName} --install /usr/bin/${executableName} ${executableName} ${executableLocation}${executableName} 20000",
    path        =>  '/usr/sbin/',
    cwd         =>  '/usr/sbin/',
  }
}


