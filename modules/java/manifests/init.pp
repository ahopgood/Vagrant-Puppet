# Class: java
#
# This module manages java
#
# Parameters: isJdk; if true then attempts to install the jdk, otherwise installs a jre, defaults to true. 
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
	#$64bit = true
	#$isJdk = true,
	$version = "6",
	$updateVersion = "45") {
	
  $local_install_path = "/etc/puppet/"
  $local_install_dir  = "${local_install_path}installers/"
  $puppet_file_dir    = "modules/java/"
  $package_name  = "jdk1.${version}.0_${updateVersion}"
  
  #Check file exists either in the puppet file server or locally in a vagrant shared folder
  
  if ("${version}" == 6){
	$jdk = "jdk-${version}u${updateVersion}-linux-amd64.rpm"
  } else {
    $jdk = "jdk-${version}u${updateVersion}-linux-x64.rpm"
  }
  #if (is64bit){
  #	$jdk = $jdk+amd64.rpm
  #}
  
  
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
  
  #How to uninstall via rpm -e package name
  #Perhaps we need to clear out any other jdk versions? Perhaps a flag could be set?
  package {
	"${package_name}":
	#ensure		=> present,
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


