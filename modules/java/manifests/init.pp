# Class: java
#
# This module manages java.
# Supported Java 6,7 & 8
# Upgrades from 6 to 7 and back are accounted for by the package manager.
# Upgrades to 8 from 6 or 7 will see the older jdk's uninstalled, downgrades will see Java 8 persist and the Java 6 or 7 installed as well. 
#
# Parameters: 
# isJdk; if true then attempts to install the jdk, otherwise installs a jre, defaults to true. 
# major_version; which indicates the version of java to install, defaults to 6.45
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
	$major_version = "6",
	$update_version = "45",
  $multiTenancy = false,
  $isDefault = false) {
	     
  $is64bit = true
  #package names are a pain
  #puppet resource package | grep -A10 packagename
  #Will help to identify the title and ensures values of a package
  #rpm -qa jdk
  #Will help to identify the names as far as rpm sees them
  notify{"Java version from hiera ${major_version}":}


  
  #Perform actions appropriate to the OS
  if $::operatingsystem == 'CentOS' {
    java::centos{"test-java-${major_version}":
      major_version => $major_version,
      update_version => $update_version,
      is64bit => $is64bit,
      multiTenancy => $multiTenancy
    }

    Java::Centos["test-java-${major_version}"] -> Java::Default::Install["install-default-to-java-${major_version}"]
    Java::Centos["test-java-${major_version}"] -> Java::Default::Set["set-default-to-java-${major_version}"]
  } elsif $::operatingsystem == 'Ubuntu'{
    include java::ubuntu::wily

    java::ubuntu{ "test-java-${major_version}":
      major_version  => $major_version,
      update_version => $update_version,
      is64bit        => $is64bit,
      multiTenancy   => $multiTenancy
    }

    Java::Ubuntu["test-java-${major_version}"] -> Java::Default::Install["install-default-to-java-${major_version}"]
    Java::Ubuntu["test-java-${major_version}"] -> Java::Default::Set["set-default-to-java-${major_version}"]
  } else {
    fail("Operating system not supported:$::operatingsystem$::operatingsystemmajrelease")
  }
  if ($isDefault == true){
    #IsDefault is false by default - probably should change this?
    java::default::install{"install-default-to-java-${major_version}":
      major_version => "${major_version}",
      update_version => "${update_version}",
    }
    ->
    java::default::set{"set-default-to-java-${major_version}":
      major_version => "${major_version}",
      update_version => "${update_version}",
    }

    if ($::operatingsystem == "Ubuntu"){
      file { "create default link":
        ensure => link,
        path => "/usr/lib/jvm/default",
        target => "/usr/lib/jvm/jdk-${major_version}-oracle-x64/",
        require => Java::Ubuntu["test-java-${major_version}"],
      }
    }
  }
}

/**
 * Used to set a particular JDK as a default using debian alternatives.
 * Requires a Java JDK installation.
 */
define java::default::install(
  $major_version = undef,
  $update_version = undef,
){
  #JDK location changes based on OS
  if ($::operatingsystem == "Ubuntu"){
    $jdkLocation    = "/usr/lib/jvm/jdk-${major_version}-oracle-x64/"
  } elsif ($::operatingsystem == "CentOS"){
    if ($update_version == undef){
      fail("CentOS Java default is missing an updateVersion")
    }
    $jdkLocation    = "/usr/java/jdk1.${major_version}.0_${update_version}/"
  } else {
    fail("operating system [${::operatingsystem}] not supported for setting defaults via alternatives")
  }

  $jdkBinLocation = "${jdkLocation}bin/"
  $jreBinLocation = "${jdkLocation}jre/bin/"
  $pluginLocation = "${jdkLocation}jre/lib/amd64/"
  $manLocation     = "${jdkLocation}man/man1/"
  $priority = 300 + "${major_version}"

  if ($major_version == 7 or $major_version == 8){
    #/bin
    alternatives::install{
      "java-${major_version}-jcmd":
      executableName      => "jcmd",
      executableLocation  => "${jdkBinLocation}",
      priority            => $priority,
      manExecutable       => "jcmd.1.gz",
      manLocation         => "${manLocation}",
    }
    #/bin
    alternatives::install{
      "java-${major_version}-jmc":
      executableName      => "jmc",
      executableLocation  => "${jdkBinLocation}",
      priority            => $priority,
      manExecutable       => "jmc.1.gz",
      manLocation         => "${manLocation}",
    }
  }
  if ($major_version == 8){
    #/bin
    alternatives::install{
      "java-${major_version}-jdeps":
      executableName      => "jdeps",
      executableLocation  => "${jdkBinLocation}",
      priority            => $priority,
      manExecutable       => "jdeps.1.gz",
      manLocation         => "${manLocation}",
    }    
  }
  
  #bin
  alternatives::install{
    "java-${major_version}-appletviewer":
    executableName      => "appletviewer",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manLocation         => "${manLocation}",
    manExecutable       => "appletviewer.1.gz",
  }
  #/jre/bin
  alternatives::install{
    "java-${major_version}-ControlPanel":
    executableName      => "ControlPanel",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
  }
  #/bin
  alternatives::install{
    "java-${major_version}-extcheck":
    executableName      => "extcheck",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manLocation         => "${manLocation}",
    manExecutable      => "extcheck.1.gz",
  }

  #/jre/lib/amd64
  alternatives::install{
    "java-${major_version}-firefox-javaplugin.so":
    executableName      => "firefox-javaplugin.so", 
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/jre/lib/amd64
  alternatives::install{
    "java-${major_version}-iceape-javaplugin.so":
    executableName      => "iceape-javaplugin.so", 
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/jre/lib/amd64
  alternatives::install{
    "java-${major_version}-iceweasel-javaplugin.so":
    executableName      => "iceweasel-javaplugin.so",
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/bin
  alternatives::install{
    "java-${major_version}-idlj":
    executableName      => "idlj",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "idlj.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${major_version}-jar":
    executableName      => "jar",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jar.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${major_version}-jarsigner":
    executableName      => "jarsigner",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jarsigner.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "java-${major_version}-java":
    executableName      => "java",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "java.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${major_version}-javac":
    executableName      => "javac",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,      
    manExecutable       => "javac.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${major_version}-javadoc":
    executableName      => "javadoc",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "javadoc.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${major_version}-javah":
    executableName      => "javah",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "javah.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${major_version}-javap":
    executableName      => "javap",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "javap.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "java-${major_version}-javaws":
    executableName      => "javaws",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "javaws.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${major_version}-jconsole":
    executableName      => "jconsole",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jconsole.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${major_version}-jdb":
    executableName      => "jdb",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jdb.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/lib
  alternatives::install{
    "java-${major_version}-jexec":
    executableName      => "jexec",
    executableLocation  => "${jdkLocation}jre/lib/",
    priority            => $priority,
  }
  #/bin
  alternatives::install{
    "java-${major_version}-jhat":
    executableName      => "jhat",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jhat.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${major_version}-jinfo":
    executableName      => "jinfo",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jinfo.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${major_version}-jmap":
    executableName      => "jmap",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jmap.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${major_version}-jps":
    executableName      => "jps",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jps.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${major_version}-jrunscript":
    executableName      => "jrunscript",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jrunscript.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${major_version}-jsadebugd":
    executableName      => "jsadebugd",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jsadebugd.1.gz",
    manLocation         => "${manLocation}",
  }
  #bin
  alternatives::install{
    "java-${major_version}-jstack":
    executableName      => "jstack",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jstack.1.gz",
    manLocation         => "${manLocation}",
  }
  #bin
  alternatives::install{
    "java-${major_version}-jstat":
    executableName      => "jstat",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jstat.1.gz",
    manLocation         => "${manLocation}",
  }
  #bin
  alternatives::install{
    "java-${major_version}-jstatd":
    executableName      => "jstatd",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jstatd.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${major_version}-jvisualvm":
    executableName      => "jvisualvm",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jvisualvm.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "java-${major_version}-keytool":
    executableName      => "keytool",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "keytool.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/lib/amd64
  alternatives::install{
    "java-${major_version}-midbrowser-javaplugin.so":
    executableName      => "midbrowser-javaplugin.so",
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/jre/lib/amd64
  alternatives::install{
    "java-${major_version}-mozilla-javaplugin.so":
    executableName      => "mozilla-javaplugin.so",
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/bin
  alternatives::install{
    "java-${major_version}-native2ascii":
    executableName      => "native2ascii",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "native2ascii.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "java-${major_version}-orbd":
    executableName      => "orbd",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "orbd.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "java-${major_version}-pack200":
    executableName      => "pack200",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "pack200.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "java-${major_version}-policytool":
    executableName      => "policytool",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "policytool.1.gz",
    manLocation         => "${manLocation}",
  }
  #bin
  alternatives::install{
    "java-${major_version}-rmic":
    executableName      => "rmic",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "rmic.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "java-${major_version}-rmid":
    executableName      => "rmid",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "rmid.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "java-${major_version}-rmiregistry":
    executableName      => "rmiregistry",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "rmiregistry.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${major_version}-schemagen":
    executableName      => "schemagen",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "schemagen.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${major_version}-serialver":
    executableName      => "serialver",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "serialver.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "java-${major_version}-servertool":
    executableName      => "servertool",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "servertool.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "java-${major_version}-tnameserv":
    executableName      => "tnameserv",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "tnameserv.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "java-${major_version}-unpack200":
    executableName      => "unpack200",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "unpack200.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${major_version}-wsgen":
    executableName      => "wsgen",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "wsgen.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${major_version}-wsimport":
    executableName      => "wsimport",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "wsimport.1.gz",
    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "java-${major_version}-xjc":
    executableName      => "xjc",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "xjc.1.gz",
    manLocation         => "${manLocation}",
  }
  #/jre/lib/amd64
  alternatives::install{
    "java-${major_version}-xulrunner-addons-javaplugin.so":
    executableName      => "xulrunner-addons-javaplugin.so",
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/jre/lib/amd64
  alternatives::install{
    "java-${major_version}-xulrunner-javaplugin.so":
    executableName      =>  "xulrunner-javaplugin.so", 
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
}

/**
 * Used to set a particular JDK as a default using debian alternatives.
 * Requires a Java JDK setation.
 */
define java::default::set(
  $major_version = undef,
  $update_version = undef,
){
  #JDK location changes based on OS
  if ($::operatingsystem == "Ubuntu"){
    $jdkLocation    = "/usr/lib/jvm/jdk-${major_version}-oracle-x64/"
  } elsif ($::operatingsystem == "CentOS"){
    if ($update_version == undef){
      fail("CentOS Java default is missing an update_version")
    }
    $jdkLocation    = "/usr/java/jdk1.${major_version}.0_${update_version}/"
  } else {
    fail("operating system [${::operatingsystem}] not supported for setting defaults via alternatives")
  }

  $jdkBinLocation = "${jdkLocation}bin/"
  $jreBinLocation = "${jdkLocation}jre/bin/"
  $pluginLocation = "${jdkLocation}jre/lib/amd64/"
  $manLocation     = "${jdkLocation}man/man1/"
  $priority = 1500 + "${major_version}"

  if ($version == 7 or $version == 8){
    #7 & 8
    #/bin
    alternatives::set{
     "jmc-set-alternative":
      executableName      => "jmc",
      executableLocation  => "${jdkBinLocation}",
      priority            => $priority,
#     manExecutable       => "jmc.1.gz",
#     manLocation         => "${jdkBinLocation}",
    }
    #7 & 8
    #/bin
    alternatives::set{
      "jcmd-set-alternative":
      executableName      => "jcmd",
      executableLocation  => "${jdkBinLocation}",
      priority            => $priority,
#     manExecutable       => "jcmd.1.gz",
#     manLocation         => "${manLocation}",
    }
  }
  if ($version == 8){
    #8
    #/bin
    alternatives::set{
      "jdeps-set-alternative":
      executableName      => "jdeps",
      executableLocation  => "${jdkBinLocation}",
      priority            => $priority,
#      manExecutable       => "jdeps.1.gz",
#      manLocation         => "${manLocation}",
    }
  }
  #bin
  alternatives::set{
    "appletviewer-set-alternative":
    executableName      => "appletviewer",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
#    manLocation         => "${manLocation}",
#    manExecutable       => "appletviewer.1.gz",
  }
  #/jre/bin
  alternatives::set{
    "ControlPanel-set-alternative":
    executableName      => "ControlPanel",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
  }
  #/bin
  alternatives::set{
    "extcheck-set-alternative":
    executableName      => "extcheck",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
#    manLocation         => "${manLocation}",
#    manExecutable      => "extcheck.1.gz",
  }

  #/jre/lib/amd64
  alternatives::set{
    "firefox-javaplugin.so-set-alternative":
    executableName      => "firefox-javaplugin.so", 
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/jre/lib/amd64
  alternatives::set{
    "iceape-javaplugin.so-set-alternative":
    executableName      => "iceape-javaplugin.so", 
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/jre/lib/amd64
  alternatives::set{
    "iceweasel-javaplugin.so-set-alternative":
    executableName      => "iceweasel-javaplugin.so",
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/bin
  alternatives::set{
    "idlj-set-alternative":
    executableName      => "idlj",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
#    manExecutable       => "idlj.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::set{
    "jar-set-alternative":
    executableName      => "jar",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
#    manExecutable       => "jar.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::set{
    "jarsigner-set-alternative":
    executableName      => "jarsigner",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
#    manExecutable       => "jarsigner.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::set{
    "java-set-alternative":
    executableName      => "java",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
#    manExecutable       => "java.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::set{
    "javac-set-alternative":
    executableName      => "javac",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,      
#    manExecutable       => "javac.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::set{
    "javadoc-set-alternative":
    executableName      => "javadoc",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
#    manExecutable       => "javadoc.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::set{
    "javah-set-alternative":
    executableName      => "javah",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
#    manExecutable       => "javah.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::set{
    "javap-set-alternative":
    executableName      => "javap",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
#    manExecutable       => "javap.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::set{
    "javaws-set-alternative":
    executableName      => "javaws",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
#    manExecutable       => "javaws.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::set{
    "jconsole-set-alternative":
    executableName      => "jconsole",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
#    manExecutable       => "jconsole.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::set{
    "jdb-set-alternative":
    executableName      => "jdb",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
#    manExecutable       => "jdb.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/lib
  alternatives::set{
    "jexec-set-alternative":
    executableName      => "jexec",
    executableLocation  => "${jdkLocation}jre/lib/",
    priority            => $priority,
  }
  #/bin
  alternatives::set{
    "jhat-set-alternative":
    executableName      => "jhat",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
#    manExecutable       => "jhat.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::set{
    "jinfo-set-alternative":
    executableName      => "jinfo",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
#    manExecutable       => "jinfo.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::set{
    "jmap-set-alternative":
    executableName      => "jmap",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
#    manExecutable       => "jmap.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::set{
    "jps-set-alternative":
    executableName      => "jps",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
#    manExecutable       => "jps.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::set{
    "jrunscript-set-alternative":
    executableName      => "jrunscript",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
#    manExecutable       => "jrunscript.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::set{
    "jsadebugd-set-alternative":
    executableName      => "jsadebugd",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
#    manExecutable       => "jsadebugd.1.gz",
#    manLocation         => "${manLocation}",
  }
  #bin
  alternatives::set{
    "jstack-set-alternative":
    executableName      => "jstack",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
#    manExecutable       => "jstack.1.gz",
#    manLocation         => "${manLocation}",
  }
  #bin
  alternatives::set{
    "jstat-set-alternative":
    executableName      => "jstat",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
#    manExecutable       => "jstat.1.gz",
#    manLocation         => "${manLocation}",
  }
  #bin
  alternatives::set{
    "jstatd-set-alternative":
    executableName      => "jstatd",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
#    manExecutable       => "jstatd",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::set{
    "jvisualvm-set-alternative":
    executableName      => "jvisualvm",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
#    manExecutable       => "jvisualvm.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::set{
    "keytool-set-alternative":
    executableName      => "keytool",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
#    manExecutable       => "keytool.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/lib/amd64
  alternatives::set{
    "midbrowser-javaplugin.so-set-alternative":
    executableName      => "midbrowser-javaplugin.so",
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/jre/lib/amd64
  alternatives::set{
    "mozilla-javaplugin.so-set-alternative":
    executableName      => "mozilla-javaplugin.so",
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/bin
  alternatives::set{
    "native2ascii-set-alternative":
    executableName      => "native2ascii",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
#    manExecutable       => "native2ascii.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::set{
    "orbd-set-alternative":
    executableName      => "orbd",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
#    manExecutable       => "orbd.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::set{
    "pack200-set-alternative":
    executableName      => "pack200",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
#    manExecutable       => "pack200.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::set{
    "policytool-set-alternative":
    executableName      => "policytool",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
#    manExecutable       => "policytool.1.gz",
#    manLocation         => "${manLocation}",
  }
  #bin
  alternatives::set{
    "rmic-set-alternative":
    executableName      => "rmic",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
#    manExecutable       => "rmic.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::set{
    "rmid-set-alternative":
    executableName      => "rmid",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
#    manExecutable       => "rmid.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::set{
    "rmiregistry-set-alternative":
    executableName      => "rmiregistry",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
#    manExecutable       => "rmiregistry.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::set{
    "schemagen-set-alternative":
    executableName      => "schemagen",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
#    manExecutable       => "schemagen.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::set{
    "serialver-set-alternative":
    executableName      => "serialver",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
#    manExecutable       => "serialver.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::set{
    "servertool-set-alternative":
    executableName      => "servertool",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
#    manExecutable       => "servertool.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::set{
    "tnameserv-set-alternative":
    executableName      => "tnameserv",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
#    manExecutable       => "tnameserv.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::set{
    "unpack200-set-alternative":
    executableName      => "unpack200",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
#    manExecutable       => "unpack200.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::set{
    "wsgen-set-alternative":
    executableName      => "wsgen",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
#    manExecutable       => "wsgen.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::set{
    "wsimport-set-alternative":
    executableName      => "wsimport",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
#    manExecutable       => "wsimport.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::set{
    "xjc-set-alternative":
    executableName      => "xjc",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
#    manExecutable       => "xjc.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/lib/amd64
  alternatives::set{
    "xulrunner-addons-javaplugin.so-set-alternative":
    executableName      => "xulrunner-addons-javaplugin.so",
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/jre/lib/amd64
  alternatives::set{
    "xulrunner-javaplugin.so-set-alternative":
    executableName      =>  "xulrunner-javaplugin.so", 
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
 }
}

define java::jce(
  $major_version = undef,
  $update_version = undef,
) {

  # Require java with a specific major major_version, how to check this?
  Java <<| |>> -> Java::Jce["${name}"]

  #Require unzip (mostly for CentOS 7 but let's not take any chances
  Class['unzip']-> Java::Jce["${name}"]

  # Derive jdk location based on OS
  if ($::operatingsystem == "Ubuntu"){
    $jdkLocation    = "/usr/lib/jvm/jdk-${major_version}-oracle-x64/"
  } elsif ($::operatingsystem == "CentOS"){
    if ($update_version == undef){
      fail("CentOS unlimited strength JCE is missing an update_version")
    }
    $jdkLocation    = "/usr/java/jdk1.${major_version}.0_${update_version}/"
  } else {
    fail("operating system [${::operatingsystem}] not supported for installing unlimited strength Java Cryptographic Extensions (JCE)")
  }

  # The JCE Zip files for each major version of Java have different internal folder names because consistency makes life boring
  if (versioncmp("${major_version}","6") == 0){
    $unpacked_jce_folder = "jce"
  } elsif (versioncmp("${major_version}","7")  == 0) {
    $unpacked_jce_folder = "UnlimitedJCEPolicy"
  } elsif (versioncmp("${major_version}","8") == 0) {
    $unpacked_jce_folder = "UnlimitedJCEPolicyJDK8"
  }

  $jce_file = "jce_policy-${major_version}.zip"
  $zipLocation = "/opt/"

  file {"${jce_file}":
    ensure => present,
    path => "${zipLocation}${jce_file}",
    source => ["puppet:///modules/${module_name}/${jce_file}"],
  }

  #Zip doens't work on CentOS_7_test
  exec {"unzip ${jce_file}":
    cwd => "${zipLocation}",
    path => "/usr/bin/",
    command => "unzip -q ${jce_file} -d ${zipLocation}jce-${major_version}",
    unless => "/bin/ls -1 ${zipLocation} | /bin/grep jce-${major_version}",
    creates => "${zipLocation}jce-${major_version}",
    require => File["${jce_file}"],
  }

  $jreLocation = "${jdkLocation}jre/"
  $securityLocation = "${jreLocation}lib/security/"
  $securityBackupLocation = "${securityLocation}original_strength_policy_jars/"

  file {"${securityBackupLocation}":
    ensure => directory,
    mode => 777,
    require => Exec["unzip ${jce_file}"]
  }

  $US_export_policy = "US_export_policy.jar"
  exec {"move Java ${major_version} default ${US_export_policy} files":
    path => "/bin/",
    command => "mv ${securityLocation}${US_export_policy} ${securityBackupLocation}",
    unless => "/bin/ls -1 ${securityBackupLocation} | /bin/grep ${US_export_policy}",
    require => File["${securityBackupLocation}"],
  }

  $local_policy = "local_policy.jar"
  exec {"move Java ${major_version} default ${local_policy} files":
    path => "/bin/",
    command => "mv ${securityLocation}${local_policy} ${securityBackupLocation}",
    unless => "/bin/ls -1 ${securityBackupLocation} | /bin/grep ${local_policy}",
    require => File["${securityBackupLocation}"],
  }

  file {"${securityLocation}${US_export_policy}":
    ensure => present,
    path => "${securityLocation}${US_export_policy}",
    source => ["${zipLocation}jce-${major_version}/${unpacked_jce_folder}/${US_export_policy}"],
    require => [
      Exec["move Java ${major_version} default ${US_export_policy} files"],
      Exec["move Java ${major_version} default ${local_policy} files"],
    ]
  }
  ->
  file {"${securityLocation}${local_policy}":
    ensure => present,
    path => "${securityLocation}${local_policy}",
    source => ["${zipLocation}jce-${major_version}/${unpacked_jce_folder}/${local_policy}"],
    require => [
      Exec["move Java ${major_version} default ${US_export_policy} files"],
      Exec["move Java ${major_version} default ${local_policy} files"],
    ]
  }
  ->
  exec {"remove JCE folder ${zipLocation}jce-${major_version}":
    path => "/bin/",
    command => "rm -rf ${zipLocation}jce-${major_version}",
    require => Exec["unzip ${jce_file}"],
  }
  ->
  exec {"remove ${jce_file}":
    path => "/bin/",
    command => "rm ${zipLocation}${jce_file}",
    require => Exec["unzip ${jce_file}"],
  }
}