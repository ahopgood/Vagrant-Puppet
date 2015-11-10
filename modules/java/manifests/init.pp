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
class java (
#	$is64bit = true, 
	#$isJdk = true,
	$version = "6",
	$updateVersion = "45") {
	
  $local_install_path = "/etc/puppet/"
  $local_install_dir  = "${local_install_path}installers/"
  $puppet_file_dir    = "modules/java/"
  
  #Check file exists either in the puppet file server or locally in a vagrant shared folder   
  $is64bit = true
  #package names are a pain
  #puppet resource package | grep -A10 packagename
  #Will help to identify the title and ensures values of a package
  #rpm -qa jdk
  #Will help to identify the names as far as rpm sees them
  notify{"Java version from hiera ${version}":}
   
	#Derive rpm file from verion number, update number and platform type
  if ("${is64bit}" == 'true'){
  	if ("${version}" > 6){
  		$platform = x64
  	} else {
	  	$platform = amd64
	}
  } else {
  	$platform = i586
  }

  if ("${version}" == 5){
  	$jdk = "jdk-1_${version}_0_${updateVersion}-linux-${platform}.rpm"
  } elsif ("${version}" == 6){
	$jdk = "jdk-${version}u${updateVersion}-linux-${platform}.rpm"
  } else {
    $jdk = "jdk-${version}u${updateVersion}-linux-${platform}.rpm"
  }
  
	#Derive package name from version and update version
  	#Java 8 rpm package name is different from previous versions so a straight up upgrade won't happen
  	#you'll end up with both versions installed so we need to ensure the previous version is absent
  if ("${version}" == 5 or "${version}" == 6 or "${version}" == 7){
    $package_name  = "jdk"
  } elsif ("${version}" == 8){
  	$package_name  = "jdk1.${version}.0_${updateVersion}"
  	$uninstall_package = "jdk"
	 package {
  		"${uninstall_package}":
        ensure 	=> absent,
  		  provider => 'rpm'
  	}
  } 

  #Setup already in filerserver
  file {
    "${local_install_dir}":
    path       =>  "${local_install_dir}",
    ensure     =>  directory,
  }
  
  file {
    "${jdk}":
    require    =>  File["${local_install_dir}"],
    path       =>  "${local_install_dir}${jdk}",
    ensure     =>  present,
    source     =>  ["puppet:///${puppet_file_dir}${jdk}"]
  }
  
  #How to uninstall via rpm: rpm -e package name
  #How to query via rpm: rpm -qa  grep 'jdk' 
  #Perhaps we need to clear out any other jdk versions? Perhaps a flag could be set?
  #RPM package names:
  #jdk1.8.0_25-1.8.0_25-fcs.x86_64
  #jdk-1.7.0_71-fcs.x86_64
  #jdk-1.6.0_45-fcs.x86_64
  #jdk-1.5.0_22-fcs.x86_64
  #32-bit
  #jdk1.8.0_25-1.8.0_25-fcs.i586
  #jdk-1.7.0_71-fcs.i586
  #jdk-1.6.0_45-fcs.i586
  #jdk-1.5.0_22-fcs.i586
  
  
  #Puppet package names
  #annoyingly the package name for 1.8 is jdk1.8.0_25
  #then more annoyingly the package names for 1.7, 1.6 and 1.5 are jdk
  #Ensure vale:
  #1.8 is 1.8.0_25-fcs
  #1.7 is 1.7.0_71-fcs
  #1.6 is 1.6.0_45-fcs
  #1.5 is 1.5.0_22-fcs
  #this means java 8 will not replace 6 or 7 due to the differing packaging names
  
  package {
	"${package_name}":
	ensure		=> "1.${version}.0_${updateVersion}-fcs",
    provider    =>  'rpm',
    source      =>  "${local_install_dir}${jdk}",
    require     =>  File["${jdk}"],
  }
  
  #It might be worth setting up an alternatives type instead of relying on the exec command.
  exec {
    'java-install-alternative':
    command     =>  "alternatives --install /usr/bin/java java /usr/java/jdk1.${version}.0_${updateVersion}/jre/bin/java 20000",
    path        =>  '/usr/sbin/',
    cwd         =>  '/usr/sbin/',
    require     =>  Package["${package_name}"],
    before      =>  Exec['java-set-alternative']
  }
  
  exec {
    'jar-install-alternative':
    command     =>  "alternatives --install /usr/bin/jar jar /usr/java/jdk1.${version}.0_${updateVersion}/bin/jar 20000",
    path        =>  '/usr/sbin/',
    cwd         =>  '/usr/sbin/',
    require     =>  Package["${package_name}"],
    before      =>  Exec['jar-set-alternative']  
  }
  
  exec {
    'javac-install-alternative':
    command     =>  "alternatives --install /usr/bin/javac javac /usr/java/jdk1.${version}.0_${updateVersion}/bin/javac 20000",
    path        =>  '/usr/sbin/',
    cwd         =>  '/usr/sbin/',
    require     =>  Package["${package_name}"],
    before      =>  Exec['javac-set-alternative']
  }
    
  exec {
    'javaws-install-alternative':
    command     =>  "alternatives --install /usr/bin/javaws javaws /usr/java/jdk1.${version}.0_${updateVersion}/jre/bin/javaws 20000",
    path        =>  '/usr/sbin/',
    cwd         =>  '/usr/sbin/',
    require     =>  Package["${package_name}"],
    before      =>  Exec['javaws-set-alternative']
  }
  
  exec {
    'java-set-alternative':
    command     =>  "alternatives --set java /usr/java/jdk1.${version}.0_${updateVersion}/jre/bin/java",
    path        =>  '/usr/sbin/',
    cwd         =>  '/usr/sbin/',
  }   
  
  exec {
    'jar-set-alternative':
    command     =>  "alternatives --set jar /usr/java/jdk1.${version}.0_${updateVersion}/bin/jar",
    path        =>  '/usr/sbin/',
    cwd         =>  '/usr/sbin/',  
  }
  
  exec {
    'javac-set-alternative':
    command     =>  "alternatives --set javac /usr/java/jdk1.${version}.0_${updateVersion}/bin/javac",  
    path        =>  '/usr/sbin/',
    cwd         =>  '/usr/sbin/',
  }
  
  exec {
    'javaws-set-alternative':
    command     =>  "alternatives --set javaws /usr/java/jdk1.${version}.0_${updateVersion}/jre/bin/javaws",
    path        =>  '/usr/sbin/',
    cwd         =>  '/usr/sbin/',
  }
  
  #  subscribe   =>  Package['java-sdk'],
  #  require     =>  Package['java-sdk'],
}


