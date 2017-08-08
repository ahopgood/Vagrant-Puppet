/**
 * Used to set a particular JDK as a default using debian alternatives.
 * Requires a Java JDK setation.
 */
define java::default::remove(
  $jdk_name = $title,
  $major_version = undef,
){
  #JDK location changes based on OS
  if ($::operatingsystem == "Ubuntu"){
    $jdkLocation    = "/usr/lib/jvm/${jdk_name}/"
  } elsif ($::operatingsystem == "CentOS"){
    $jdkLocation    = "/usr/java/${jdk_name}"
  } else {
    fail("operating system [${::operatingsystem}] not supported for setting defaults via alternatives")
  }
  $jdkBinLocation = "${jdkLocation}/bin/"
  $jreBinLocation = "${jdkLocation}/jre/bin/"
  $pluginLocation = "${jdkLocation}/jre/lib/amd64/"
  $manLocation     = "${jdkLocation}/man/man1/"
  $priority = 1500 + "${major_version}"
  
  $constants = { priority => "${priority}", jdkLocation => "${jdkLocation}"}
  
  java::default::remove::onlyif{
    "firefox-javaplugin.so-remove-alternative-from-${jdk_name}":
      executableName      => "firefox-javaplugin.so",
      execAlias           => "libnpjp2.so",
      executableLocation  => "${pluginLocation}",
      constants           => $constants 
  }
#  #/jre/lib/amd64
  java::default::remove::onlyif{
    "iceape-javaplugin.so-set-alternative-from-${jdk_name}":
      executableName      => "iceape-javaplugin.so",
      execAlias           => "libnpjp2.so",
      executableLocation  => "${pluginLocation}",
      constants           => $constants
  }
#  #/jre/lib/amd64
  java::default::remove::onlyif{
    "iceweasel-javaplugin.so-set-alternative-from-${jdk_name}":
      executableName      => "iceweasel-javaplugin.so",
      execAlias           => "libnpjp2.so",
      executableLocation  => "${pluginLocation}",
      constants           => $constants
  }
#  #/jre/bin
  java::default::remove::onlyif{
    "java-set-alternative-from-${jdk_name}":
      executableName      => "java",
      executableLocation  => "${jreBinLocation}",
      constants           => $constants
  }
#  #/bin
  java::default::remove::onlyif{
    "javac-set-alternative-from-${jdk_name}":
      executableName      => "javac",
      executableLocation  => "${jdkBinLocation}",
      constants           => $constants
  }
#  #/jre/lib/amd64
  java::default::remove::onlyif{
    "midbrowser-javaplugin.so-set-alternative-from-${jdk_name}":
      executableName      => "midbrowser-javaplugin.so",
      execAlias           => "libnpjp2.so",
      executableLocation  => "${pluginLocation}",
      constants           => $constants
  }
#  #/jre/lib/amd64
  java::default::remove::onlyif{
    "mozilla-javaplugin.so-set-alternative-from-${jdk_name}":
      executableName      => "mozilla-javaplugin.so",
      execAlias           => "libnpjp2.so",
      executableLocation  => "${pluginLocation}",
      constants           => $constants
  }
#  #/jre/lib/amd64
  java::default::remove::onlyif{
    "xulrunner-addons-javaplugin.so-set-alternative-from-${jdk_name}":
      executableName      => "xulrunner-addons-javaplugin.so",
      execAlias           => "libnpjp2.so",
      executableLocation  => "${pluginLocation}",
      constants           => $constants
  }
#  #/jre/lib/amd64
  java::default::remove::onlyif{
    "xulrunner-javaplugin.so-set-alternative-from-${jdk_name}":
      executableName      =>  "xulrunner-javaplugin.so",
      execAlias           => "libnpjp2.so",
      executableLocation  => "${pluginLocation}",
      constants           => $constants
  }
}

define java::default::remove::onlyif(
  $executableName      = undef,
  $execAlias           = undef,
  $executableLocation  = undef,
  $constants           = undef
){
  if $::operatingsystem == 'CentOS' {
    $alternativesName = "alternatives"
  } elsif $::operatingsystem == 'Ubuntu' {
    $alternativesName = "update-alternatives"
  } else {
    notify {"${::operatingsystem} is not supported":}
  }
  $jdkLocation = $constants[jdkLocation]
  $onlyif = "/usr/sbin/${alternativesName} --display ${executableName} | /bin/grep \"${jdkLocation}.*${execAlias} - priority *\" > /dev/null"
  
  alternatives::remove{
    "${title} with onlyif":
      executableName      => $executableName,
      execAlias           => $execAlias,
      executableLocation  => $constants[jdkLocation],
      priority            => $constants[priority],
      onlyif              => "${onlyif}",
  }
}