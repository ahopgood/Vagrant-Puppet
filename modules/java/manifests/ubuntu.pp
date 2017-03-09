define java::ubuntu(
  $major_version = "6",
  $update_version = "45",
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
    $jdk = "oracle-java${major_version}-jdk_${major_version}u${update_version}_${platform}-${::operatingsystem}_${::operatingsystemmajrelease}.deb"
    #Java deb format example oracle_java8-jdk_8u112_amd64-Ubuntu_15.10.deb
    
    if $::operatingsystemmajrelease == "15.10" {
      notify{"We're on Ubuntu wiley trying to use Java package ${jdk}":}
 
      if ($multiTenancy){
        notify{"Java ${major_version}":
          message => "Multi tenancy JVMs allowed"
        }
      } else {
        notify{"Java ${major_version}":
          message => "Multi tenancy JVMs not supported"
        }
      
        $versionsToRemove = {
          "6" => ["oracle-java7-jdk","oracle-java8-jdk"],
          "7" => ["oracle-java6-jdk","oracle-java8-jdk"],
          "8" => ["oracle-java6-jdk","oracle-java7-jdk"],
        }   
      
        package {
          $versionsToRemove["${major_version}"]:
          ensure      => "purged",
          provider    =>  'dpkg',
        }
      }#end multi-tenancy else
 
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
      "oracle-java${major_version}-jdk":
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
          Package["oracle-java${major_version}-jdk"]]
      }
    }
}

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

/**
 * Used to set a particular JDK as a default using debian alternatives.
 * Requires a Java JDK setation.
 */
define java::ubuntu::default::set(
  $version = undef,
){
  $jdkLocation    = "/usr/lib/jvm/jdk-${version}-oracle-x64/"
  $jdkBinLocation = "${jdkLocation}bin/"
  $jreBinLocation = "${jdkLocation}jre/bin/"
  $pluginLocation = "${jdkLocation}jre/lib/amd64/"
  $manLocation     = "${jdkLocation}man/man1/"
  $priority = 1500 + "${version}"

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
#    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/jre/lib/amd64
  alternatives::set{
    "iceape-javaplugin.so-set-alternative":
    executableName      => "iceape-javaplugin.so", 
#    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/jre/lib/amd64
  alternatives::set{
    "iceweasel-javaplugin.so-set-alternative":
    executableName      => "iceweasel-javaplugin.so",
#    execAlias           => "libnpjp2.so",
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
#    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/jre/lib/amd64
  alternatives::set{
    "mozilla-javaplugin.so-set-alternative":
    executableName      => "mozilla-javaplugin.so",
#    execAlias           => "libnpjp2.so",
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
#    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
  #/jre/lib/amd64
  alternatives::set{
    "xulrunner-javaplugin.so-set-alternative":
    executableName      =>  "xulrunner-javaplugin.so", 
#    execAlias           => "libnpjp2.so",
    executableLocation  => "${pluginLocation}",
    priority            => $priority,
  }
}
