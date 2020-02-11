/**
 * Used to remove a particular JDK from default using debian alternatives.
 * Requires a Java JDK location.
 */
define java::oracle::default::remove (
  $major_version = undef,
  $update_version = undef,
){
  #JDK location changes based on OS
    if ($::operatingsystem == "Ubuntu") {
      $jdkLocation = "/usr/lib/jvm/jdk-${major_version}-oracle-x64/"
    } elsif ($::operatingsystem == "CentOS") {
      if ($update_version == undef) {
        fail("CentOS Java default is missing an update_version")
      }
      $jdkLocation = "/usr/java/jdk1.${major_version}.0_${update_version}/"
    } else {
      fail("operating system [${::operatingsystem}] not supported for setting defaults via alternatives")
    }

    $jdkBinLocation = "${jdkLocation}bin/"
    $jreBinLocation = "${jdkLocation}jre/bin/"
    $pluginLocation = "${jdkLocation}jre/lib/amd64/"
    $manLocation = "${jdkLocation}man/man1/"
    $priority = 1500 + "${major_version}"

    #/jre/lib/amd64
    alternatives::remove {
      "firefox-javaplugin.so-remove-alternative":
        executableName     => "firefox-javaplugin.so",
        execAlias          => "libnpjp2.so",
        executableLocation => "${pluginLocation}",
    }
    #/jre/lib/amd64
    alternatives::remove {
      "iceape-javaplugin.so-remove-alternative":
        executableName     => "iceape-javaplugin.so",
        execAlias          => "libnpjp2.so",
        executableLocation => "${pluginLocation}",
    }
    #/jre/lib/amd64
    alternatives::remove {
      "iceweasel-javaplugin.so-remove-alternative":
        executableName     => "iceweasel-javaplugin.so",
        execAlias          => "libnpjp2.so",
        executableLocation => "${pluginLocation}",
    }
    #/jre/bin
    alternatives::remove {
      "java-remove-alternative":
        executableName     => "java",
        executableLocation => "${jreBinLocation}",
    }
    #/bin
    alternatives::remove {
      "javac-remove-alternative":
        executableName     => "javac",
        executableLocation => "${jdkBinLocation}",
    }
    #/jre/lib
    alternatives::remove {
      "jexec-remove-alternative":
        executableName     => "jexec",
        executableLocation => "${jdkLocation}jre/lib/",
    }
    #/jre/lib/amd64
    alternatives::remove {
      "midbrowser-javaplugin.so-remove-alternative":
        executableName     => "midbrowser-javaplugin.so",
        execAlias          => "libnpjp2.so",
        executableLocation => "${pluginLocation}",
    }
    #/jre/lib/amd64
    alternatives::remove {
      "mozilla-javaplugin.so-remove-alternative":
        executableName     => "mozilla-javaplugin.so",
        execAlias          => "libnpjp2.so",
        executableLocation => "${pluginLocation}",
    }
    #/jre/lib/amd64
    alternatives::remove {
      "xulrunner-addons-javaplugin.so-remove-alternative":
        executableName     => "xulrunner-addons-javaplugin.so",
        execAlias          => "libnpjp2.so",
        executableLocation => "${pluginLocation}",
    }
    #/jre/lib/amd64
    alternatives::remove {
      "xulrunner-javaplugin.so-remove-alternative":
        executableName     => "xulrunner-javaplugin.so",
        execAlias          => "libnpjp2.so",
        executableLocation => "${pluginLocation}",
    }
}