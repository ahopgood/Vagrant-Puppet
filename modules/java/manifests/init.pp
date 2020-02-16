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
#    Java::Centos["test-java-${major_version}"] -> Java::Default::Set["set-default-to-java-${major_version}"]
  } elsif $::operatingsystem == 'Ubuntu'{
    # include java::ubuntu::wily

    java::ubuntu{ "test-java-${major_version}":
      major_version  => $major_version,
      update_version => $update_version,
      is64bit        => $is64bit,
      multiTenancy   => $multiTenancy
    }

    Java::Ubuntu["test-java-${major_version}"] -> Java::Default::Install["install-default-to-java-${major_version}"]
#    Java::Ubuntu["test-java-${major_version}"] -> Java::Default::Set["set-default-to-java-${major_version}"]
  } else {
    fail("Operating system not supported:$::operatingsystem$::operatingsystemmajrelease")
  }

  java::default::install{"install-default-to-java-${major_version}":
    major_version => "${major_version}",
    update_version => "${update_version}",
  }

  if ($isDefault == true){
    #IsDefault is false by default - probably should change this?
    Java::Default::Install["install-default-to-java-${major_version}"] -> Java::Default::Set["set-default-to-java-${major_version}"]

    java::default::set{"set-default-to-java-${major_version}":
      major_version => "${major_version}",
      update_version => "${update_version}",
    }

    if (versioncmp("${operatingsystem}", "Ubuntu") == 0){
      if (
        ((versioncmp("${major_version}", "8") == 0) and (versioncmp("${update_version}", "212") > 0 ) )
        or
        (versioncmp("${major_version}", "11") == 0)
      ) {
        # Trigger the default to be set and used
        java::openjdk::ubuntu::set_default{"Set OpenJDK default":
          major_version => "${major_version}",
          from_create => true,
        }
      } else {
        file { "create default link ${major_version}":
          ensure => link,
          path => "/usr/lib/jvm/default",
          target => "/usr/lib/jvm/jdk-${major_version}-oracle-x64/",
          require => Java::Ubuntu["test-java-${major_version}"],
        }
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
  if (
    (($::operatingsystem == "Ubuntu") and (versioncmp("${major_version}", "8") == 0) and (versioncmp("${update_version}", "212") > 0 ) )
  or
    (($::operatingsystem == "Ubuntu") and (versioncmp("${major_version}", "11") == 0))
  ) {
    # Do nothing for AdoptOpenJdk installations as they already install themselves but try to install the default if one is pre-configuredd
    java::openjdk::ubuntu::set_default { "Set default for OpenJdk ${major_version}":
      major_version => "${major_version}"
    }
  } else { # Oracle Java block
    java::oracle::default::install { "Set default for Oracle JDK ${major_version}":
      major_version => "${major_version}",
      update_version => "${update_version}"
    }
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
  if (
    (($::operatingsystem == "Ubuntu") and (versioncmp("${major_version}", "8") == 0) and (versioncmp("${update_version}", "212") > 0 ) )
    or
    (($::operatingsystem == "Ubuntu") and (versioncmp("${major_version}", "11") == 0))
  ) {
    java::openjdk::ubuntu::create_default { "Set default for OpenJdk ${major_version}":
      major_version => "${major_version}"
    }
  } else {

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
    alternatives::set {
      "firefox-javaplugin.so-set-alternative":
        executableName     => "firefox-javaplugin.so",
        execAlias          => "libnpjp2.so",
        executableLocation => "${pluginLocation}",
        priority           => $priority,
    }
    #/jre/lib/amd64
    alternatives::set {
      "iceape-javaplugin.so-set-alternative":
        executableName     => "iceape-javaplugin.so",
        execAlias          => "libnpjp2.so",
        executableLocation => "${pluginLocation}",
        priority           => $priority,
    }
    #/jre/lib/amd64
    alternatives::set {
      "iceweasel-javaplugin.so-set-alternative":
        executableName     => "iceweasel-javaplugin.so",
        execAlias          => "libnpjp2.so",
        executableLocation => "${pluginLocation}",
        priority           => $priority,
    }
    #/jre/bin
    alternatives::set {
      "java-set-alternative":
        executableName     => "java",
        executableLocation => "${jreBinLocation}",
        priority           => $priority,
    }
    #/bin
    alternatives::set {
      "javac-set-alternative":
        executableName     => "javac",
        executableLocation => "${jdkBinLocation}",
        priority           => $priority,
    }
    #/jre/lib
    alternatives::set {
      "jexec-set-alternative":
        executableName     => "jexec",
        executableLocation => "${jdkLocation}jre/lib/",
        priority           => $priority,
    }
    #/jre/lib/amd64
    alternatives::set {
      "midbrowser-javaplugin.so-set-alternative":
        executableName     => "midbrowser-javaplugin.so",
        execAlias          => "libnpjp2.so",
        executableLocation => "${pluginLocation}",
        priority           => $priority,
    }
    #/jre/lib/amd64
    alternatives::set {
      "mozilla-javaplugin.so-set-alternative":
        executableName     => "mozilla-javaplugin.so",
        execAlias          => "libnpjp2.so",
        executableLocation => "${pluginLocation}",
        priority           => $priority,
    }
    #/jre/lib/amd64
    alternatives::set {
      "xulrunner-addons-javaplugin.so-set-alternative":
        executableName     => "xulrunner-addons-javaplugin.so",
        execAlias          => "libnpjp2.so",
        executableLocation => "${pluginLocation}",
        priority           => $priority,
    }
    #/jre/lib/amd64
    alternatives::set {
      "xulrunner-javaplugin.so-set-alternative":
        executableName     => "xulrunner-javaplugin.so",
        execAlias          => "libnpjp2.so",
        executableLocation => "${pluginLocation}",
        priority           => $priority,
    }
  }
}

define java::jce(
  $major_version = undef,
  $update_version = undef,
) {

  # Require java with a specific major major_version, how to check this?
  Java <<| |>> -> Java::Jce["${name}"]

  #Require unzip mostly for CentOS 7 but let's not take any chances
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

  $us_export_policy = "US_export_policy.jar"
  exec {"move Java ${major_version} default ${us_export_policy} files":
    path => "/bin/",
    command => "mv ${securityLocation}${us_export_policy} ${securityBackupLocation}",
    unless => "/bin/ls -1 ${securityBackupLocation} | /bin/grep ${us_export_policy}",
    require => File["${securityBackupLocation}"],
  }

  $local_policy = "local_policy.jar"
  exec {"move Java ${major_version} default ${local_policy} files":
    path => "/bin/",
    command => "mv ${securityLocation}${local_policy} ${securityBackupLocation}",
    unless => "/bin/ls -1 ${securityBackupLocation} | /bin/grep ${local_policy}",
    require => File["${securityBackupLocation}"],
  }

  file {"${securityLocation}${us_export_policy}":
    ensure => present,
    path => "${securityLocation}${us_export_policy}",
    source => ["${zipLocation}jce-${major_version}/${unpacked_jce_folder}/${us_export_policy}"],
    require => [
      Exec["move Java ${major_version} default ${us_export_policy} files"],
      Exec["move Java ${major_version} default ${local_policy} files"],
    ]
  }
  ->
  file {"${securityLocation}${local_policy}":
    ensure => present,
    path => "${securityLocation}${local_policy}",
    source => ["${zipLocation}jce-${major_version}/${unpacked_jce_folder}/${local_policy}"],
    require => [
      Exec["move Java ${major_version} default ${us_export_policy} files"],
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