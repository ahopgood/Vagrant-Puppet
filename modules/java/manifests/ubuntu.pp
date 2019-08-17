define java::ubuntu(
  $major_version = "6",
  $update_version = "45",
  $is64bit = true,
  $multiTenancy = undef
){
  $local_install_path = "/etc/puppet/"
  $local_install_dir  = "${local_install_path}installers/"
  $puppet_file_dir    = "modules/java/"

  # If required add into manifest at sites.pp
  # file {"${local_install_dir}":
  #   ensure => directory,
  #   path       =>  "${local_install_dir}",
  # }
  
  if ("${is64bit}"=="true") {
    $platform = "amd64"
  } else {
    notify {"32-bit Java is not supported currently for ${::operatingsystem} ${::operatingsystemmajrelease}":}
  }

    #create name of java deb file
    $jdk = "oracle-java${major_version}-jdk_${major_version}u${update_version}_${platform}-${::operatingsystem}_${::operatingsystemmajrelease}.deb"
    #Java deb format example oracle_java8-jdk_8u112_amd64-Ubuntu_15.10.deb
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

  $package_name = "oracle-java${major_version}-jdk"
  if (versioncmp("${operatingsystemmajrelease}", "15.10") == 0) {
    notify{"We're on Ubuntu Wily trying to use Java package ${jdk}":}
    java::ubuntu::wily {"Wily ${package_name}u${update_version}":
      package_name   => "${package_name}",
      update_version => "${update_version}"
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
    #      package {
    #      "remove orcale-java${major_version}-jdk":
    #        name        => "oracle-java${major_version}-jdk",
    #        ensure      => "purged",
    #        provider    =>  'dpkg',
    #        #onlyif      => "${major_version} ${update_version} aren't equal
    #      }

    package {
      "${package_name}u${update_version}":
        #        name        => "${package_name}",
        provider    =>  'dpkg',
        source      =>  "${local_install_dir}${jdk}",
        require     =>  [
          File["${jdk}"],
          #          Package["remove oracle-java${major_version}-jdk"]
        ]
    }
  } elsif (versioncmp("${operatingsystemmajrelease}", "16.04") == 0) {
    notify{"We're on Ubuntu Xenial trying to use Java package ${jdk}":}
    java::ubuntu::xenial{"xenial ${package_name}u${update_version}":
      java_package => "${package_name}u${update_version}",
      major_version => "${major_version}",
      update_version => "${update_version}"
    }
  } else {
    fail("${operatingsystemmajrelease} not supported for Java package ${jdk}")
  } #End OS Check
}

define java::ubuntu::wily(
  $package_name = undef,
  $update_version = undef
){
  $local_install_path = "/etc/puppet/"
  $local_install_dir  = "${local_install_path}installers/"
  $puppet_file_dir    = "modules/java/"

      $libasound_data = "libasound2-data_1.0.29-0ubuntu1_all.deb"
      file {"${libasound_data}":
        require    =>  File["${local_install_dir}"],
        path       =>  "${local_install_dir}${libasound_data}",
        ensure     =>  present,
        source     =>  ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${libasound_data}"]
      }
      package {
      "libasound2-data":
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
      "libasound2":
        ensure      => installed,
        provider    =>  'dpkg',
        source      =>  "${local_install_dir}${libasound}",
        require     =>  [File["${libasound}"],
#          Package["${libasound_data}"],
          Package["libasound2-data"],
        ],
        before      =>  Package["${package_name}u${update_version}"]
      }

      $libgtk_common = "libgtk2.0-common_2.24.28-1ubuntu1.1_all.deb"
      file {"${libgtk_common}":
        require    =>  File["${local_install_dir}"],
        path       =>  "${local_install_dir}${libgtk_common}",
        ensure     =>  present,
        source     =>  ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${libgtk_common}"]
      }
      package {
      "libgtk2.0-common":
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
      "libgtk2.0-0":
        ensure      => installed,
        provider    =>  'dpkg',
        source      =>  "${local_install_dir}${libgtk}",
        require     =>  [File["${libgtk}"],
#          Package["${libgtk_common}"],
          Package["libgtk2.0-common"]
        ]
      } 
}
