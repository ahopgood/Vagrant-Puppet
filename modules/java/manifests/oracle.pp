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

define java::oracle::default::install (
  $major_version = undef,
  $update_version = undef,
) {
  #JDK location changes based on OS
  if ($::operatingsystem == "Ubuntu") {
    $jdkLocation = "/usr/lib/jvm/jdk-${major_version}-oracle-x64/"
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
  $manLocation    = "${jdkLocation}man/man1/"
  $priority = 100000  + (1000 * "${major_version}") + "${update_version}"
  #e.g. java 8u112 and 7u80 respectively:
  #100000 + 8000 = 180000 + 112 = 180112
  #100000 + 7000 = 170000 + 80 = 1700080

  $manExt = ".1"
  # Common binaries that are slaved to the java command
  $javaSlaveCommonHash = {
    # "ControlPanel" => "${jreBinLocation}",
    "javaws"       => "${jreBinLocation}",
    # "jcontrol"     => "${jreBinLocation}",
    "keytool"      => "${jreBinLocation}",
    "orbd"         => "${jreBinLocation}",
    "pack200"      => "${jreBinLocation}",
    # "policytool"   => "${jreBinLocation}",
    "rmid"         => "${jreBinLocation}",
    "rmiregistry"  => "${jreBinLocation}",
    "servertool"   => "${jreBinLocation}",
    "tnameserv"    => "${jreBinLocation}",
    "unpack200"    => "${jreBinLocation}",
  }

  $javaManSlaveCommonHash = {
    "javaws${manExt}"      => "${manLocation}",
    "keytool${manExt}"     => "${manLocation}",
    "orbd${manExt}"        => "${manLocation}",
    "pack200${manExt}"     => "${manLocation}",
    # "policytool${manExt}"  => "${manLocation}",
    "rmid${manExt}"        => "${manLocation}",
    "rmiregistry${manExt}" => "${manLocation}",
    "servertool${manExt}"  => "${manLocation}",
    "tnameserv${manExt}"   => "${manLocation}",
    "unpack200${manExt}"   => "${manLocation}",
  }

  # Common binaries and man files that are slaved to the javac command
  $javaCompilerslaveCommonHash = {
    "appletviewer"            => "${jdkBinLocation}",
    "ControlPanel"            => "${jreBinLocation}",
    "extcheck"                => "${jdkBinLocation}",
    "idlj"                    => "${jdkBinLocation}",
    "jar"                     => "${jdkBinLocation}",
    "jarsigner"               => "${jdkBinLocation}",
    "javadoc"                 => "${jdkBinLocation}",
    "javah"                   => "${jdkBinLocation}",
    "javap"                   => "${jdkBinLocation}",
    # "javaws"                  => "${jreBinLocation}",
    "jconsole"                => "${jdkBinLocation}",
    "jcontrol"                => "${jreBinLocation}",
    "jdb"                     => "${jdkBinLocation}",
    "jhat"                    => "${jdkBinLocation}",
    "jinfo"                   => "${jdkBinLocation}",
    "jmap"                    => "${jdkBinLocation}",
    "jps"                     => "${jdkBinLocation}",
    "jrunscript"              => "${jdkBinLocation}",
    "jsadebugd"               => "${jdkBinLocation}",
    "jstack"                  => "${jdkBinLocation}",
    "jstat"                   => "${jdkBinLocation}",
    "jstatd"                  => "${jdkBinLocation}",
    "jvisualvm"               => "${jdkBinLocation}",
    # "keytool"                 => "${jreBinLocation}",
    "native2ascii"            => "${jdkBinLocation}",
    # "orbd"                    => "${jreBinLocation}",
    # "pack200"                 => "${jreBinLocation}",
    "policytool"              => "${jreBinLocation}",
    "rmic"                    => "${jdkBinLocation}",
    # "rmid"                    => "${jreBinLocation}",
    # "rmiregistry"             => "${jreBinLocation}",
    "schemagen"               => "${jdkBinLocation}",
    "serialver"               => "${jdkBinLocation}",
    # "servertool"              => "${jreBinLocation}",
    # "tnameserv"               => "${jreBinLocation}",
    # "unpack200"               => "${jreBinLocation}",
    "wsgen"                   => "${jdkBinLocation}",
    "wsimport"                => "${jdkBinLocation}",
    "xjc"                     => "${jdkBinLocation}",
  }
  $javaCompilersManSlaveCommonHash = {
    "appletviewer${manExt}"   => "${manLocation}",
    "extcheck${manExt}"       => "${manLocation}",
    "idlj${manExt}"           => "${manLocation}",
    "jar${manExt}"            => "${manLocation}",
    "jarsigner${manExt}"      => "${manLocation}",
    "java${manExt}"           => "${manLocation}",
    "javac${manExt}"          => "${manLocation}",
    "javadoc${manExt}"        => "${manLocation}",
    "javah${manExt}"          => "${manLocation}",
    "javap${manExt}"          => "${manLocation}",
    # "javaws${manExt}"         => "${manLocation}",
    "jconsole${manExt}"       => "${manLocation}",
    "jdb${manExt}"            => "${manLocation}",
    "jhat${manExt}"           => "${manLocation}",
    "jinfo${manExt}"          => "${manLocation}",
    "jmap${manExt}"           => "${manLocation}",
    "jps${manExt}"            => "${manLocation}",
    "jrunscript${manExt}"     => "${manLocation}",
    "jsadebugd${manExt}"      => "${manLocation}",
    "jstack${manExt}"         => "${manLocation}",
    "jstat${manExt}"          => "${manLocation}",
    "jstatd${manExt}"         => "${manLocation}",
    "jvisualvm${manExt}"      => "${manLocation}",
    # "keytool${manExt}"        => "${manLocation}",
    "native2ascii${manExt}"   => "${manLocation}",
    # "orbd${manExt}"           => "${manLocation}",
    # "pack200${manExt}"        => "${manLocation}",
    "policytool${manExt}"     => "${manLocation}",
    "rmic${manExt}"           => "${manLocation}",
    # "rmid${manExt}"           => "${manLocation}",
    # "rmiregistry${manExt}"    => "${manLocation}",
    "schemagen${manExt}"      => "${manLocation}",
    "serialver${manExt}"      => "${manLocation}",
    # "servertool${manExt}"     => "${manLocation}",
    # "tnameserv${manExt}"      => "${manLocation}",
    # "unpack200${manExt}"      => "${manLocation}",
    "wsgen${manExt}"          => "${manLocation}",
    "wsimport${manExt}"       => "${manLocation}",
    "xjc${manExt}"            => "${manLocation}",
  }

  if (versioncmp("${major_version}", "8") == 0){
    $javaSlaveVersionSpecificHash = {
      "jjs"                     => "${jreBinLocation}", #java 8 only
    }
    $javaManSlaveVersionSpecificHash = {
      "jjs${manExt}"            => "${manLocation}", #java 8 only
    }
    $javaCompilerslaveVersionSpecificHash = {
      "java-rmi.cgi"            => "${jdkBinLocation}",
      "javafxpackager"          => "${jdkBinLocation}",
      "javapackager"            => "${jdkBinLocation}", #java 8 only
      "jdeps"                   => "${jdkBinLocation}",
      "jcmd"                    => "${jdkBinLocation}",
      # "jjs"                     => "${jreBinLocation}", #java 8 only
      "jmc"                     => "${jdkBinLocation}",
      "jmc.ini"                 => "${jdkBinLocation}",
    }
    $javaCompilersManSlaveVersionSpecificHash = {
      "javafxpackager${manExt}" => "${manLocation}",
      "javapackager${manExt}"   => "${manLocation}", #java 8 only
      "jcmd${manExt}"           => "${manLocation}",
      "jdeps${manExt}"          => "${manLocation}",
      # "jjs${manExt}"            => "${manLocation}", #java 8 only
      "jmc${manExt}"            => "${manLocation}",
    }
  } elsif (versioncmp("${major_version}", "7") == 0) {
    $javaSlaveVersionSpecificHash = { # checked
      "java_vm"              => "${jreBinLocation}",
    }
    $javaManSlaveVersionSpecificHash = {}
    $javaCompilerslaveVersionSpecificHash = {
      "apt"                     => "${jdkBinLocation}",
      "java-rmi.cgi"            => "${jdkBinLocation}",
      "javafxpackager"          => "${jdkBinLocation}",
      "jcmd"                    => "${jdkBinLocation}",
      "jmc"                     => "${jdkBinLocation}",
      "jmc.ini"                 => "${jdkBinLocation}",
    }
    $javaCompilersManSlaveVersionSpecificHash = {
      "apt${manExt}"            => "${manLocation}",
      "javafxpackager${manExt}" => "${manLocation}",
      "jcmd${manExt}"           => "${manLocation}",
      "jmc${manExt}"            => "${manLocation}",
    }
  } elsif (versioncmp("${major_version}", "6") == 0) { # java 6
    $javaSlaveVersionSpecificHash = { # checked
      "java_vm"              => "${jreBinLocation}",
    }
    $javaManSlaveVersionSpecificHash = {}
    $javaCompilerslaveVersionSpecificHash = {
      "HtmlConverter"           => "${jdkBinLocation}",
      "apt"                     => "${jdkBinLocation}",
    }
    $javaCompilersManSlaveVersionSpecificHash = {
      "apt${manExt}"            => "${manLocation}",
    }
  } else {
    fail("Java ${major_version} alternatives not supported")
  }
  #Merge common hash of java slaves with version specific ones
  $javaSlaveHash = $javaSlaveCommonHash+$javaSlaveVersionSpecificHash
  $javaManSlaveHash = $javaManSlaveCommonHash+$javaManSlaveVersionSpecificHash
  #Merge common hash of javac slaves with version specific ones
  $javaCompilerslaveHash=$javaCompilerslaveCommonHash+$javaCompilerslaveVersionSpecificHash
  $javaCompilersManSlaveHash = $javaCompilersManSlaveCommonHash+$javaCompilersManSlaveVersionSpecificHash


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

  #/jre/bin
  alternatives::install{
    "java-${major_version}-java":
      executableName      => "java",
      executableLocation  => "${jreBinLocation}",
      priority            => $priority,
      manExecutable       => "java${manExt}",
      manLocation         => "${manLocation}",
      slaveBinariesHash   => $javaSlaveHash,
      slaveManPagesHash   => $javaManSlaveHash,
  }
  #/bin
  alternatives::install{
    "java-${major_version}-javac":
      executableName      => "javac",
      executableLocation  => "${jdkBinLocation}",
      priority            => $priority,
      manExecutable       => "javac${manExt}",
      manLocation         => "${manLocation}",
      slaveBinariesHash   => $javaCompilerslaveHash,
      slaveManPagesHash   => $javaCompilerManSlaveHash,
  }

  #/jre/lib
  alternatives::install{
    "java-${major_version}-jexec":
      executableName      => "jexec",
      executableLocation  => "${jdkLocation}jre/lib/",
      priority            => $priority,
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