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
    java::centos{"test-java-${version}":
      version => $version,
      updateVersion => $updateVersion,
      is64bit => $is64bit,
      multiTenancy => $multiTenancy
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



/**
 * Used to set a particular JDK as a default using debian alternatives.
 * Requires a Java JDK installation.
 */
define java::default::install(
  $version = undef,
  $updateVersion = undef,
){
  #JDK location changes based on OS
  if ($::operatingsystem == "Ubuntu"){
    $jdkLocation    = "/usr/lib/jvm/jdk-${version}-oracle-x64/"    
  } elsif ($::operatingsystem == "CentOS"){
    if ($updateVersion == undef){
      fail("CentOS Java default is missing an updateVersion")
    }
    $jdkLocation    = "/usr/java/jdk1.${version}.0_${updateVersion}/"
  } else {
    fail("operating system [${::operatingsystem}] not supported for setting defaults via alternatives")
  }

  $jdkBinLocation = "${jdkLocation}bin/"
  $jreBinLocation = "${jdkLocation}jre/bin/"
  $pluginLocation = "${jdkLocation}jre/lib/amd64/"
  $manLocation     = "${jdkLocation}man/man1/"
  $priority = 300 + "${version}"

  if ($version == 7 or $version == 8){
    #/bin
    alternatives::install{
      "java-${version}-jcmd-install-alternative":
      executableName      => "jcmd",
      executableLocation  => "${jdkBinLocation}",
      priority            => $priority,
      manExecutable       => "jcmd.1.gz",
      manLocation         => "${manLocation}",
    }
    #/bin
    alternatives::install{
      "java-${version}-jmc-install-alternative":
      executableName      => "jmc",
      executableLocation  => "${jdkBinLocation}",
      priority            => $priority,
      manExecutable       => "jmc.1.gz",
      manLocation         => "${manLocation}",
    }
  }
  if ($version == 8){
    #/bin
    alternatives::install{
      "java-${version}-jdeps-install-alternative":
      executableName      => "jdeps",
      executableLocation  => "${jdkBinLocation}",
      priority            => $priority,
      manExecutable       => "jdeps.1.gz",
      manLocation         => "${manLocation}",
    }    
  }
  
  #bin
  alternatives::install{
    "java-${version}-appletviewer-install-alternative":
    executableName      => "appletviewer",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manLocation         => "${manLocation}",
    manExecutable       => "appletviewer.1.gz",
  }
  #/jre/bin
  alternatives::install{
    "java-${version}-ControlPanel-install-alternative":
    executableName      => "ControlPanel",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
  }
  #/bin
  alternatives::install{
    "java-${version}-extcheck-install-alternative":
    executableName      => "extcheck",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manLocation         => "${manLocation}",
    manExecutable      => "extcheck.1.gz",
  }

  #/jre/lib/amd64
  alternatives::install{
    "java-${version}-firefox-javaplugin.so-install-alternative":
    executableName      => "firefox-javaplugin.so", 
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/jre/lib/amd64
  alternatives::install{
    "java-${version}-iceape-javaplugin.so-install-alternative":
    executableName      => "iceape-javaplugin.so", 
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/jre/lib/amd64
  alternatives::install{
    "java-${version}-iceweasel-javaplugin.so-install-alternative":
    executableName      => "iceweasel-javaplugin.so",
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/bin
  alternatives::install{
    "java-${version}-idlj-install-alternative":
    executableName      => "idlj",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "idlj.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${version}-jar-install-alternative":
    executableName      => "jar",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jar.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${version}-jarsigner-install-alternative":
    executableName      => "jarsigner",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jarsigner.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "java-${version}-java-install-alternative":
    executableName      => "java",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "java.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${version}-javac-install-alternative":
    executableName      => "javac",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,      
    manExecutable       => "javac.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${version}-javadoc-install-alternative":
    executableName      => "javadoc",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "javadoc.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${version}-javah-install-alternative":
    executableName      => "javah",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "javah.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${version}-javap-install-alternative":
    executableName      => "javap",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "javap.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "java-${version}-javaws-install-alternative":
    executableName      => "javaws",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "javaws.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${version}-jconsole-install-alternative":
    executableName      => "jconsole",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jconsole.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${version}-jdb-install-alternative":
    executableName      => "jdb",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jdb.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/lib
  alternatives::install{
    "java-${version}-jexec-install-alternative":
    executableName      => "jexec",
    executableLocation  => "${jdkLocation}jre/lib/",
    priority            => $priority,
  }
  #/bin
  alternatives::install{
    "java-${version}-jhat-install-alternative":
    executableName      => "jhat",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jhat.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${version}-jinfo-install-alternative":
    executableName      => "jinfo",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jinfo.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${version}-jmap-install-alternative":
    executableName      => "jmap",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jmap.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${version}-jps-install-alternative":
    executableName      => "jps",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jps.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${version}-jrunscript-install-alternative":
    executableName      => "jrunscript",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jrunscript.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${version}-jsadebugd-install-alternative":
    executableName      => "jsadebugd",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jsadebugd.1.gz",
    manLocation         => "${manLocation}",
  }
  #bin
  alternatives::install{
    "java-${version}-jstack-install-alternative":
    executableName      => "jstack",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jstack.1.gz",
    manLocation         => "${manLocation}",
  }
  #bin
  alternatives::install{
    "java-${version}-jstat-install-alternative":
    executableName      => "jstat",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jstat.1.gz",
    manLocation         => "${manLocation}",
  }
  #bin
  alternatives::install{
    "java-${version}-jstatd-install-alternative":
    executableName      => "jstatd",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jstatd.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${version}-jvisualvm-install-alternative":
    executableName      => "jvisualvm",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jvisualvm.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "java-${version}-keytool-install-alternative":
    executableName      => "keytool",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "keytool.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/lib/amd64
  alternatives::install{
    "java-${version}-midbrowser-javaplugin.so-install-alternative":
    executableName      => "midbrowser-javaplugin.so",
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/jre/lib/amd64
  alternatives::install{
    "java-${version}-mozilla-javaplugin.so-install-alternative":
    executableName      => "mozilla-javaplugin.so",
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/bin
  alternatives::install{
    "java-${version}-native2ascii-install-alternative":
    executableName      => "native2ascii",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "native2ascii.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "java-${version}-orbd-install-alternative":
    executableName      => "orbd",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "orbd.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "java-${version}-pack200-install-alternative":
    executableName      => "pack200",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "pack200.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "java-${version}-policytool-install-alternative":
    executableName      => "policytool",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "policytool.1.gz",
    manLocation         => "${manLocation}",
  }
  #bin
  alternatives::install{
    "java-${version}-rmic-install-alternative":
    executableName      => "rmic",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "rmic.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "java-${version}-rmid-install-alternative":
    executableName      => "rmid",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "rmid.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "java-${version}-rmiregistry-install-alternative":
    executableName      => "rmiregistry",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "rmiregistry.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${version}-schemagen-install-alternative":
    executableName      => "schemagen",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "schemagen.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${version}-serialver-install-alternative":
    executableName      => "serialver",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "serialver.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "java-${version}-servertool-install-alternative":
    executableName      => "servertool",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "servertool.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "java-${version}-tnameserv-install-alternative":
    executableName      => "tnameserv",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "tnameserv.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "java-${version}-unpack200-install-alternative":
    executableName      => "unpack200",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "unpack200.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${version}-wsgen-install-alternative":
    executableName      => "wsgen",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "wsgen.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${version}-wsimport-install-alternative":
    executableName      => "wsimport",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "wsimport.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${version}-xjc-install-alternative":
    executableName      => "xjc",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "xjc.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/lib/amd64
  alternatives::install{
    "java-${version}-xulrunner-addons-javaplugin.so-install-alternative":
    executableName      => "xulrunner-addons-javaplugin.so",
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/jre/lib/amd64
  alternatives::install{
    "java-${version}-xulrunner-javaplugin.so-install-alternative":
    executableName      =>  "xulrunner-javaplugin.so", 
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
}

