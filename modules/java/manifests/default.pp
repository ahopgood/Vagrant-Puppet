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
#    if ($update_version == undef){
#      fail("CentOS Java default is missing an update_version")
#    }
    $jdkLocation    = "/usr/java/${jdk_name}"
    notify{"${jdkLocation}":}
#    fail("Removal of Java Alternatives isn't supported on CentOS")
  } else {
    fail("operating system [${::operatingsystem}] not supported for setting defaults via alternatives")
  }
  $jdkBinLocation = "${jdkLocation}/bin/"
  $jreBinLocation = "${jdkLocation}/jre/bin/"
  $pluginLocation = "${jdkLocation}/jre/lib/amd64/"
  $manLocation     = "${jdkLocation}/man/man1/"
  $priority = 1500 + "${major_version}"
  
  #alternatives --display java | grep "/usr/java/jdk1.7.0_*.*/jre/bin/java - priority"

#  $onlyif = "/usr/sbin/${alternativesName} --display ${executableName} | /bin/grep \"${jdkLocation}.*${targetExecutable} - priority *\" > /dev/null"

  #/jre/lib/amd64
  java::default::remove::onlyif{
    "firefox-javaplugin.so-remove-alternative-from-${jdk_name}":
      executableName      => "firefox-javaplugin.so",
      execAlias           => "libnpjp2.so",
      executableLocation  => "${pluginLocation}",
      constants           => { priority => "${priority}", jdkLocation => "${jdkLocation}"}
  }
#  #/jre/lib/amd64
#  alternatives::set{
#    "iceape-javaplugin.so-set-alternative":
#      executableName      => "iceape-javaplugin.so",
#      execAlias           => "libnpjp2.so",
#      executableLocation  => "${pluginLocation}",
#      priority            => $priority,
#  }
#  #/jre/lib/amd64
#  alternatives::set{
#    "iceweasel-javaplugin.so-set-alternative":
#      executableName      => "iceweasel-javaplugin.so",
#      execAlias           => "libnpjp2.so",
#      executableLocation  => "${pluginLocation}",
#      priority            => $priority,
#  }
#  #/jre/bin
#  alternatives::set{
#    "java-set-alternative":
#      executableName      => "java",
#      executableLocation  => "${jreBinLocation}",
#      priority            => $priority,
#  }
#  #/bin
#  alternatives::set{
#    "javac-set-alternative":
#      executableName      => "javac",
#      executableLocation  => "${jdkBinLocation}",
#      priority            => $priority,
#  }
#  #/jre/lib/amd64
#  alternatives::set{
#    "midbrowser-javaplugin.so-set-alternative":
#      executableName      => "midbrowser-javaplugin.so",
#      execAlias           => "libnpjp2.so",
#      executableLocation  => "${pluginLocation}",
#      priority            => $priority,
#  }
#  #/jre/lib/amd64
#  alternatives::set{
#    "mozilla-javaplugin.so-set-alternative":
#      executableName      => "mozilla-javaplugin.so",
#      execAlias           => "libnpjp2.so",
#      executableLocation  => "${pluginLocation}",
#      priority            => $priority,
#  }
#  #/jre/lib/amd64
#  alternatives::set{
#    "xulrunner-addons-javaplugin.so-set-alternative":
#      executableName      => "xulrunner-addons-javaplugin.so",
#      execAlias           => "libnpjp2.so",
#      executableLocation  => "${pluginLocation}",
#      priority            => $priority,
#  }
#  #/jre/lib/amd64
#  alternatives::set{
#    "xulrunner-javaplugin.so-set-alternative":
#      executableName      =>  "xulrunner-javaplugin.so",
#      execAlias           => "libnpjp2.so",
#      executableLocation  => "${pluginLocation}",
#      priority            => $priority,
#  }
}

define java::default::remove::onlyif(
  $executableName      = "firefox-javaplugin.so",
  $execAlias           = "libnpjp2.so",
  $executableLocation  = "${pluginLocation}",
  $constants           = undef
){
  if $::operatingsystem == 'CentOS' {
    $alternativesName = "alternatives"
  } elsif $::operatingsystem == 'Ubuntu' {
    $alternativesName = "update-alternatives"
  } else {
    notify {"${::operatingsystem} is not supported":}
  }
  #onlyif
  #/usr/sbin/alternatives --display firefox-javaplugin.so | /bin/grep "/usr/java/jdk1.8.0_.*.*libnpjp2.so - priority *"
  #removal
  #alternatives --remove firefox-javaplugin.so /usr/java/jdk1.8.0_*/jre/lib/amd64/libnpjp2.so
  $jdkLocation = $constants[jdkLocation]
  $onlyif = "/usr/sbin/${alternativesName} --display ${executableName} | /bin/grep \"${jdkLocation}.*${execAlias} - priority *\" > /dev/null"
  
  #try "alternatives --remove java $(alternatives --display java | grep "/usr/java/jdk1.7.0_.*java - priority" | awk '{ print $1 }')"

  alternatives::remove{
    "${title} with onlyif":
      executableName      => $executableName,
      execAlias           => $execAlias,
      executableLocation  => $constants[jdkLocation],
      priority            => $constants[priority],
      onlyif              => "${onlyif}",
  }
}