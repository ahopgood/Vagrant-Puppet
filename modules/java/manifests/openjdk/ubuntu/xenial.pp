define java::openjdk::ubuntu::xenial(
  $java_package = undef,
  $major_version = undef,
  $update_version = undef,
  $multiTenancy = false,
) {

  #   wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -
  #   sudo add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
  #   sudo apt-get update
  #   apt-get install adoptopenjdk-8-hotspot
  # For older versions:
  # https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/pool/main/a/adoptopenjdk-8-hotspot/

  # Set alternatives
  # sudo update-java-alternatives -s adoptopenjdk-8-hotspot-amd64

  if ($multiTenancy) {
    notify{"Java ${major_version}":
      message => "Multi tenancy JVMs allowed"
    }
  } else {
    notify{"Java ${major_version}":
      message => "Multi tenancy JVMs not supported"
    }

    java::oracle::default::remove{"remove-default-for-java-${major_version}":
      major_version => "${major_version}",
      update_version => "${update_version}",
      before => Package["adoptopenjdk-${major_version}-hotspot"]
    }

    $packagedVersionsToRemove = {
      "8" => ["adoptopenjdk-11-hotspot"],
      "11" => ["adoptopenjdk-8-hotspot"],
    }
    package {
      $packagedVersionsToRemove["${major_version}"]:
        ensure      => "purged",
        provider    =>  'dpkg',
    }
    $jvm_home_directory = "/usr/lib/jvm/"
    $versionsToRemove = {
      "8" => ["${jvm_home_directory}jdk-6-oracle-x64","${jvm_home_directory}jdk-7-oracle-x64","${jvm_home_directory}jdk-8-oracle-x64"],
      "11" => ["${jvm_home_directory}jdk-6-oracle-x64","${jvm_home_directory}jdk-7-oracle-x64","${jvm_home_directory}jdk-8-oracle-x64"],
    }

    file {
      $versionsToRemove["${major_version}"]:
        ensure => "absent",
        force => true,
        require => [Java::Oracle::Default::Remove["remove-default-for-java-${major_version}"]]
    }
  }

  $java_common_file_name = "java-common_0.56ubuntu2_all.deb"
  $libasound2_file_name = "libasound2_1.1.0-0ubuntu1_amd64.deb"
  $libasound2_data_file_name = "libasound2-data_1.1.0-0ubuntu1_all.deb"
  $libxi6_file_name = "libxi6_2%3a1.7.6-1_amd64.deb"
  $x11_common_file_name = "x11-common_1%3a7.7+13ubuntu3.1_all.deb"
  $libxrender1_file_name = "libxrender1_1%3a0.9.9-0ubuntu1_amd64.deb"
  $libxtst6_file_name = "libxtst6_2%3a1.2.2-1_amd64.deb"

  if (versioncmp("${major_version}", "8") == 0) {
    realize(File["${java_common_file_name}"])
    realize(Package["java-common"])
    realize(File["${libasound2_file_name}"])
    realize(Package["libasound2"])
    realize(File["${libasound2_data_file_name}"])
    realize(Package["libasound2-data"])
    realize(File["${libxi6_file_name}"])
    realize(Package["libxi6"])
    realize(File["${x11_common_file_name}"])
    realize(Package["x11-common"])
    realize(File["${libxrender1_file_name}"])
    realize(Package["libxrender1"])
    realize(File["${libxtst6_file_name}"])
    realize(Package["libxtst6"])

    $updateExtension = {
      "222" => "b10-2",
      "232" => "b09-2",
      "242" => "b08-2",
    }
    $extension = $updateExtension["${update_version}"]

    $adoptopenjdk_8_hotspot_file_name = "adoptopenjdk-8-hotspot_8u${update_version}-${extension}_amd64.deb"
    file { "${adoptopenjdk_8_hotspot_file_name}":
      ensure => present,
      path   => "${local_install_dir}${adoptopenjdk_8_hotspot_file_name}",
      source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${
        adoptopenjdk_8_hotspot_file_name}",
    }

    package { "adoptopenjdk-8-hotspot":
      ensure   => latest,
      provider => dpkg,
      source   => "${local_install_dir}${adoptopenjdk_8_hotspot_file_name}",
      require  => [
        File["${adoptopenjdk_8_hotspot_file_name}"],
        Package["java-common"],
        Package["libasound2"],
        Package["libxi6"],
        Package["libxrender1"],
        Package["libxtst6"],
      ]
    }
  } elsif (versioncmp("${major_version}", "11") == 0 ) {
    realize(File["${java_common_file_name}"])
    realize(Package["java-common"])
    realize(File["${libasound2_file_name}"])
    realize(Package["libasound2"])
    realize(File["${libasound2_data_file_name}"])
    realize(Package["libasound2-data"])
    realize(File["${libxi6_file_name}"])
    realize(Package["libxi6"])
    realize(File["${x11_common_file_name}"])
    realize(Package["x11-common"])
    realize(File["${libxrender1_file_name}"])
    realize(Package["libxrender1"])
    realize(File["${libxtst6_file_name}"])
    realize(Package["libxtst6"])

    $updateExtension = {
      "3" => "+7-1",
      "4" => "+11-2",
      "5" => "+10-2",
      "6" => "+10-2",
    }
    $extension = $updateExtension["${update_version}"]

    $adoptopenjdk_11_hotspot_file_name = "adoptopenjdk-11-hotspot_11.0.${update_version}${extension}_amd64.deb"
    file { "${adoptopenjdk_11_hotspot_file_name}":
      ensure => present,
      path   => "${local_install_dir}${adoptopenjdk_11_hotspot_file_name}",
      source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${
        adoptopenjdk_11_hotspot_file_name}",
    }

    package { "adoptopenjdk-11-hotspot":
      ensure   => latest,
      provider => dpkg,
      source   => "${local_install_dir}${adoptopenjdk_11_hotspot_file_name}",
      require  => [
        File["${adoptopenjdk_11_hotspot_file_name}"],
        Package["java-common"],
        Package["libasound2"],
        Package["libxi6"],
        Package["libxrender1"],
        Package["libxtst6"],
      ]
    }
  } else {
    fail("AdoptOpenJDK Java version ${major_version} is not supported")
  }
  include java::openjdk::ubuntu::xenial::deps
}

class java::openjdk::ubuntu::xenial::deps() {
  # Packages common to AdoptOpenJDK packages on Ubuntu Xenial
  $java_common_file_name = "java-common_0.56ubuntu2_all.deb"
  $libasound2_file_name = "libasound2_1.1.0-0ubuntu1_amd64.deb"
  $libasound2_data_file_name = "libasound2-data_1.1.0-0ubuntu1_all.deb"
  $libxi6_file_name = "libxi6_2%3a1.7.6-1_amd64.deb"
  $x11_common_file_name = "x11-common_1%3a7.7+13ubuntu3.1_all.deb"
  $libxrender1_file_name = "libxrender1_1%3a0.9.9-0ubuntu1_amd64.deb"
  $libxtst6_file_name = "libxtst6_2%3a1.2.2-1_amd64.deb"

  @file { "${java_common_file_name}":
    ensure => present,
    path   => "${local_install_dir}${java_common_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${java_common_file_name}",
  }
  @package { "java-common":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${java_common_file_name}",
    require  => [
      File["${java_common_file_name}"],
    ]
  }

  @file { "${libasound2_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libasound2_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libasound2_file_name}",
  }
  @package { "libasound2":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libasound2_file_name}",
    require  => [
      File["${libasound2_file_name}"],
      Package["libasound2-data"],
    ]
  }

  @file { "${libasound2_data_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libasound2_data_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libasound2_data_file_name}",
  }
  @package { "libasound2-data":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libasound2_data_file_name}",
    require  => [
      File["${libasound2_data_file_name}"],
    ]
  }

  @file { "${libxi6_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libxi6_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libxi6_file_name}",
  }
  @package { "libxi6":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libxi6_file_name}",
    require  => [
      File["${libxi6_file_name}"],
      Package["x11-common"],
    ]
  }

  @file { "${x11_common_file_name}":
    ensure => present,
    path   => "${local_install_dir}${x11_common_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${x11_common_file_name}",
  }
  @package { "x11-common":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${x11_common_file_name}",
    require  => [
      File["${x11_common_file_name}"],
    ]
  }

  @file { "${libxrender1_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libxrender1_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libxrender1_file_name}",
  }
  @package { "libxrender1":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libxrender1_file_name}",
    require  => [
      File["${libxrender1_file_name}"],
    ]
  }

  @file { "${libxtst6_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libxtst6_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libxtst6_file_name}",
  }
  @package { "libxtst6":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libxtst6_file_name}",
    require  => [
      File["${libxtst6_file_name}"],
    ]
  }
}