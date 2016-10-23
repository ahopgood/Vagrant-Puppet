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
  
    #Setup already in filerserver
  file {
    "${local_install_dir}":
    path       =>  "${local_install_dir}",
    ensure     =>  directory,
  }
  
  #Perform actions appropriate to the OS
  if $::operatingsystem == 'CentOS' {
    class {"java::centos":
      version => $version,
      updateVersion => $updateVersion,
      is64bit => $is64bit
    }
  } elsif $::operatingsystem == "Ubuntu"{
    #create name of java deb file
    $jdk = "oracle-java${$version}-jdk_${$version}u${$updateVersion}_amd64-${::operatingsystem}_${::operatingsystemmajrelease}.deb"
    #Java deb format example oracle_java8-jdk_8u112_amd64-Ubuntu_15.10.deb
    
    if $::operatingsystemmajrelease == "15.10" {
      notify{"We're on Ubuntu wiley trying to use Java package ${jdk}":}
            
      $libasound_data = "libasound2-data_1.0.29-0ubuntu1_all.deb"
      file {"${libasound_data }":
        require    =>  File["${local_install_dir}"],
        path       =>  "${local_install_dir}${libasound_data}",
        ensure     =>  present,
        source     =>  ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${libasound_data}"]
      }
      package {
      "${libasound_data}":
        ensure      => installed,
        provider    =>  'dpkg',
        source      =>  "${local_install_dir}${libasound_data}",
        require     =>  File["${libasound_data}"],
      }

      $libasound = "libasound2_1.0.29-0ubuntu1_amd64.deb"
      file {"${libasound}":
        require    =>  File["${local_install_dir}"],
        path       =>  "${local_install_dir}${libasound}",
        ensure     =>  present,
        source     =>  ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${libasound}"]
      }
      package {
      "${libasound}":
        ensure      => installed,
        provider    =>  'dpkg',
        source      =>  "${local_install_dir}${libasound}",
        require     =>  [File["${libasound}"],Package["${libasound_data}"]]
      }

      $libgtk_common = "libgtk2.0-common_2.24.28-1ubuntu1.1_all.deb"
      file {"${libgtk_common}":
        require    =>  File["${local_install_dir}"],
        path       =>  "${local_install_dir}${libgtk_common}",
        ensure     =>  present,
        source     =>  ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${libgtk_common}"]
      }
      package {
      "${libgtk_common}":
        ensure      => installed,
        provider    =>  'dpkg',
        source      =>  "${local_install_dir}${libgtk_common}",
        require     =>  File["${libgtk_common}"],
      } 

      $libgtk = "libgtk2.0-0_2.24.28-1ubuntu1.1_amd64.deb"
      file {"${libgtk}":
        require    =>  File["${local_install_dir}"],
        path       =>  "${local_install_dir}${libgtk}",
        ensure     =>  present,
        source     =>  ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${libgtk}"]
      }
      package {
      "${libgtk}":
        ensure      => installed,
        provider    =>  'dpkg',
        source      =>  "${local_install_dir}${libgtk}",
        require     =>  [File["${libgtk}"],Package["${libgtk_common}"]]
      }    
      
	    file {
	      "${jdk}":
	      require    =>  File["${local_install_dir}"],
	      path       =>  "${local_install_dir}${jdk}",
	      ensure     =>  present,
	      source     =>  ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${jdk}"]
	    }  	         
	    
      #Oracle JDK packages according to puppet;
      #package { 'java-package':
      #package { 'oracle-java6-jdk':
      #package { 'oracle-java7-jdk':
      #package { 'oracle-java8-jdk':
      
      #Clear any previous update versions
      package {
      "oracle-java${version}-jdk":
        ensure      => "purged",
        provider    =>  'dpkg',
      }
      
      $package_name = "${jdk}"
      package {
      "${package_name}":
        provider    =>  'dpkg',
        source      =>  "${local_install_dir}${jdk}",
        require     =>  [
          File["${jdk}"],
          Package["${libasound}"],
          Package["${libgtk}"],
          Package["oracle-java${version}-jdk"]]
      }
    }    
  } else {
    notify {  "Operating system not supported:$::operatingsystem$::operatingsystemmajrelease":  }  
  }
  
  #  subscribe   =>  Package['java-sdk'],
  #  require     =>  Package['java-sdk'],
}


