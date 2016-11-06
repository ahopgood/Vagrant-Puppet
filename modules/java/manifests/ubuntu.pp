class java::ubuntu::wily(){
  $local_install_path = "/etc/puppet/"
  $local_install_dir  = "${local_install_path}${name}/"
  $puppet_file_dir    = "modules/java/"
  
  file {"${local_install_dir}":
    ensure => directory,
    path       =>  "${local_install_dir}",
  }

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
}

define java::ubuntu(
  $version = "",
  $updateVersion = "",
  $is64bit = true,
  $multiTenancy = undef
){
  $local_install_path = "/etc/puppet/"
  $local_install_dir  = "${local_install_path}${name}/"
  $puppet_file_dir    = "modules/java/"
      
  file{ "${local_install_dir}":
    ensure => directory,
    path       =>  "${local_install_dir}",
  }    
  
  if ("${is64bit}"=="true") {
    $platform = "amd64"
  } else {
    notify {"32-bit Java is not supported currently for ${::operatingsystem} ${::operatingsystemmajrelease}":}
  }

    #create name of java deb file
    $jdk = "oracle-java${$version}-jdk_${$version}u${$updateVersion}_${platform}-${::operatingsystem}_${::operatingsystemmajrelease}.deb"
    #Java deb format example oracle_java8-jdk_8u112_amd64-Ubuntu_15.10.deb
    
    if $::operatingsystemmajrelease == "15.10" {
      notify{"We're on Ubuntu wiley trying to use Java package ${jdk}":}
 
    if ($multiTenancy){
      notify{"Java ${version}":
        message => "Multi tenancy JVMs allowed"
      }
    } else {
      notify{"Java ${version}":
        message => "Multi tenancy JVMs not supported"
      }
      
      $versionsToRemove = {
        "6" => ["oracle-java7-jdk","oracle-java8-jdk"],
        "7" => ["oracle-java6-jdk","oracle-java8-jdk"],
        "8" => ["oracle-java6-jdk","oracle-java7-jdk"],
      }   
      
      package {
        $versionsToRemove["${version}"]:
        ensure      => "purged",
        provider    =>  'dpkg',
      }
    }
 
    include java::ubuntu::wily
      
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
          Package["oracle-java${version}-jdk"]]
      }
    }
}

/**
 * Used to set a particular JDK as a default using debian alternatives.
 * Requires a Java JDK installation.
 */
define java::ubuntu::default(
  $version = undef,
){
  $jdkLocation    = "/usr/lib/jvm/jdk-${version}-oracle-x64/"
  $jdkBinLocation = "${jdkLocation}bin/"
  $jreBinLocation = "${jdkLocation}jre/bin/"
  $pluginLocation = "${jdkLocation}jre/lib/amd64/"
  $manLocation     = "${jdkLocation}man/man1/"
  $priority = 1400 + "${version}"
  
#  alternatives::set{
#    "java-install-alternative":
#    executableName      => "java",
#    executableLocation  => "${executableLocation}",      
#  }
  #bin
  alternatives::install{
    "appletviewer-install-alternative":
    executableName      => "appletviewer",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manLocation         => "${manLocation}",
    manExecutable       => "appletviewer.1.gz",
  }
  #/jre/bin
  alternatives::install{
    "ControlPanel-install-alternative":
    executableName      => "ControlPanel",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
  }
  #/bin
  alternatives::install{
    "extcheck-install-alternative":
    executableName      => "extcheck",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manLocation         => "${manLocation}",
    manExecutable      => "extcheck.1.gz",
  }

  #/jre/lib/amd64
  alternatives::install{
    "firefox-javaplugin.so-install-alternative":
    executableName      => "firefox-javaplugin.so", 
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/jre/lib/amd64
  alternatives::install{
    "iceape-javaplugin.so-install-alternative":
    executableName      => "iceape-javaplugin.so", 
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/jre/lib/amd64
  alternatives::install{
    "iceweasel-javaplugin.so-install-alternative":
    executableName      => "iceweasel-javaplugin.so",
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/bin
  alternatives::install{
    "idlj-install-alternative":
    executableName      => "idlj",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "idlj.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "jar-install-alternative":
    executableName      => "jar",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jar.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "jarsigner-install-alternative":
    executableName      => "jarsigner",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jarsigner.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "java-install-alternative":
    executableName      => "java",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "java.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "javac-install-alternative":
    executableName      => "javac",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,      
    manExecutable       => "javac.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "javadoc-install-alternative":
    executableName      => "javadoc",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "javadoc.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "javah-install-alternative":
    executableName      => "javah",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "javah.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "javap-install-alternative":
    executableName      => "javap",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "javap.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "javaws-install-alternative":
    executableName      => "javaws",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "javaws.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "jcmd-install-alternative":
    executableName      => "jcmd",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jcmd.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "jconsole-install-alternative":
    executableName      => "jconsole",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jconsole.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "jdb-install-alternative":
    executableName      => "jdb",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jdb.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "jdeps-install-alternative":
    executableName      => "jdeps",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jdeps.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/lib
  alternatives::install{
    "jexec-install-alternative":
    executableName      => "jexec",
    executableLocation  => "${jdkLocation}jre/lib/",
    priority            => $priority,
  }
  #/bin
  alternatives::install{
    "jhat-install-alternative":
    executableName      => "jhat",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jhat.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "jinfo-install-alternative":
    executableName      => "jinfo",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jinfo.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "jmap-install-alternative":
    executableName      => "jmap",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jmap.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "jmc-install-alternative":
    executableName      => "jmc",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jmc.1.gz",
#    manLocation         => "${jdkBinLocation}",
  }
  #/bin
  alternatives::install{
    "jps-install-alternative":
    executableName      => "jps",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jps.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "jrunscript-install-alternative":
    executableName      => "jrunscript",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jrunscript.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "jsadebugd-install-alternative":
    executableName      => "jsadebugd",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jsadebugd.1.gz",
#    manLocation         => "${manLocation}",
  }
  #bin
  alternatives::install{
    "jstack-install-alternative":
    executableName      => "jstack",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jstack.1.gz",
#    manLocation         => "${manLocation}",
  }
  #bin
  alternatives::install{
    "jstat-install-alternative":
    executableName      => "jstat",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jstat.1.gz",
#    manLocation         => "${manLocation}",
  }
  #bin
  alternatives::install{
    "jstatd-install-alternative":
    executableName      => "jstatd",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jstatd",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "jvisualvm-install-alternative":
    executableName      => "jvisualvm",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "jvisualvm.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "keytool-install-alternative":
    executableName      => "keytool",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "keytool.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/lib/amd64
  alternatives::install{
    "midbrowser-javaplugin.so-install-alternative":
    executableName      => "midbrowser-javaplugin.so",
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/jre/lib/amd64
  alternatives::install{
    "mozilla-javaplugin.so-install-alternative":
    executableName      => "mozilla-javaplugin.so",
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/bin
  alternatives::install{
    "native2ascii-install-alternative":
    executableName      => "native2ascii",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "native2ascii.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "orbd-install-alternative":
    executableName      => "orbd",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "orbd.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "pack200-install-alternative":
    executableName      => "pack200",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "pack200.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "policytool-install-alternative":
    executableName      => "policytool",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "policytool.1.gz",
#    manLocation         => "${manLocation}",
  }
  #bin
  alternatives::install{
    "rmic-install-alternative":
    executableName      => "rmic",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "rmic.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "rmid-install-alternative":
    executableName      => "rmid",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "rmid.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "rmiregistry-install-alternative":
    executableName      => "rmiregistry",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "rmiregistry.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "schemagen-install-alternative":
    executableName      => "schemagen",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "schemagen.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "serialver-install-alternative":
    executableName      => "serialver",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "serialver.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "servertool-install-alternative":
    executableName      => "servertool",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "servertool.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "tnameserv-install-alternative":
    executableName      => "tnameserv",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "tnameserv.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/bin
  alternatives::install{
    "unpack200-install-alternative":
    executableName      => "unpack200",
    executableLocation  => "${jreBinLocation}",
    priority            => $priority,
    manExecutable       => "unpack200.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "wsgen-install-alternative":
    executableName      => "wsgen",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "wsgen.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "wsimport-install-alternative":
    executableName      => "wsimport",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "wsimport.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/bin
  alternatives::install{
    "xjc-install-alternative":
    executableName      => "xjc",
    executableLocation  => "${jdkBinLocation}",
    priority            => $priority,
    manExecutable       => "xjc.1.gz",
#    manLocation         => "${manLocation}",
  }
  #/jre/lib/amd64
  alternatives::install{
    "xulrunner-addons-javaplugin.so-install-alternative":
    executableName      => "xulrunner-addons-javaplugin.so",
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/jre/lib/amd64
  alternatives::install{
    "xulrunner-javaplugin.so-install-alternative":
    executableName      =>  "xulrunner-javaplugin.so", 
    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
}



#Error: update-alternatives --install /usr/bin/jar jar /usr/lib/jvm/jdk-6-oracle-x64/bin/jar 20000 returned 2 instead of one of [0]
#Error: /Stage[main]/Main/Java::Ubuntu::Default[set-default-to-java-6]/Alternatives::Install[jar-install-alternative]/Exec[install-alternative-jar]/returns: change from notrun to 0 failed: update-alternatives --install /usr/bin/jar jar /usr/lib/jvm/jdk-6-oracle-x64/bin/jar 20000 returned 2 instead of one of [0]