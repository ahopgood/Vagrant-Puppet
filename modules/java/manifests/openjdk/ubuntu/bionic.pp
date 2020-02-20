define  java::openjdk::ubuntu::bionic(
  $multiTenancy = undef,
  $major_version = undef,
  $update_version = undef,
) {
  #sudo puppet apply /vagrant/tests/openjdk.pp --modulepath=/etc/puppet/modules/
  $local_install_path = "/etc/puppet/"
  $local_install_dir  = "${local_install_path}installers/"
  $puppet_file_dir    = "modules/java/"

  notify{"Within BIONIC!":}

  include java::openjdk::ubuntu::bionic::deps
  realize(Package["${java::openjdk::ubuntu::bionic::deps::java_common_package_name}"],
    Package["${java::openjdk::ubuntu::bionic::deps::libasound2_package_name}"],
    Package["${java::openjdk::ubuntu::bionic::deps::libxi6_package_name}"],
    Package["${java::openjdk::ubuntu::bionic::deps::libxtst6_package_name}"],
    Package["${java::openjdk::ubuntu::bionic::deps::libxrender1_package_name}"])

  if (versioncmp("${major_version}", "8") == 0) {
    $updateExtension = {
      "222" => "b10-2",
      "232" => "b09-2",
      "242" => "b08-2",
    }

    $extension = $updateExtension["${update_version}"]

    $adoptopenjdk_8_hotspot_file_name = "adoptopenjdk-${major_version}-hotspot_${major_version}u${update_version}-${extension}_amd64.deb"
    $adoptopenjdk_8_hotspot_package_name = "adoptopenjdk-${major_version}-hotspot"
    file { "${adoptopenjdk_8_hotspot_file_name}":
      ensure => present,
      path   => "${local_install_dir}${adoptopenjdk_8_hotspot_file_name}",
      source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${adoptopenjdk_8_hotspot_file_name}",
    }
    package { "${adoptopenjdk_8_hotspot_package_name}":
      ensure   => present,
      provider => dpkg,
      source   => "${local_install_dir}${adoptopenjdk_8_hotspot_file_name}",
      require  => [
        File["${adoptopenjdk_8_hotspot_file_name}"],
        Package["${java::openjdk::ubuntu::bionic::deps::java_common_package_name}"],
        Package["${java::openjdk::ubuntu::bionic::deps::libasound2_package_name}"],
        Package["${java::openjdk::ubuntu::bionic::deps::libxi6_package_name}"],
        Package["${java::openjdk::ubuntu::bionic::deps::libxtst6_package_name}"],
        Package["${java::openjdk::ubuntu::bionic::deps::libxrender1_package_name}"],
      ]
    }
  } elsif (versioncmp("${major_version}", "11") == 0) {
    $updateExtension = {
      "3" => "+7-1",
      "4" => "+11-2",
      "5" => "+10-2",
      "6" => "+10-2",
    }
    $extension = $updateExtension["${update_version}"]

    $adoptopenjdk_8_hotspot_file_name = "adoptopenjdk-${major_version}-hotspot_${major_version}.0.${update_version}${extension}_amd64.deb"
    $adoptopenjdk_8_hotspot_package_name = "adoptopenjdk-${major_version}-hotspot"
    file { "${adoptopenjdk_8_hotspot_file_name}":
      ensure => present,
      path   => "${local_install_dir}${adoptopenjdk_8_hotspot_file_name}",
      source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${adoptopenjdk_8_hotspot_file_name}",
    }
    package { "${adoptopenjdk_8_hotspot_package_name}":
      ensure   => present,
      provider => dpkg,
      source   => "${local_install_dir}${adoptopenjdk_8_hotspot_file_name}",
      require  => [
        File["${adoptopenjdk_8_hotspot_file_name}"],
        Package["${java::openjdk::ubuntu::bionic::deps::java_common_package_name}"],
        Package["${java::openjdk::ubuntu::bionic::deps::libasound2_package_name}"],
        Package["${java::openjdk::ubuntu::bionic::deps::libxi6_package_name}"],
        Package["${java::openjdk::ubuntu::bionic::deps::libxtst6_package_name}"],
        Package["${java::openjdk::ubuntu::bionic::deps::libxrender1_package_name}"],
      ]
    }
  } else {
    fail("AdoptOpenJDK version ${major_version} is not supported on ${operatingsystem} ${operatingsystemmajrelease}")
  }

}

class java::openjdk::ubuntu::bionic::deps {
  $local_install_path = "/etc/puppet/"
  $local_install_dir  = "${local_install_path}installers/"
  $puppet_file_dir    = "modules/java/"
  #Java 8 deps
  $java_common_file_name = "java-common_0.68ubuntu1~18.04.1_all.deb"
  $java_common_package_name = "java-common"
  $libxtst6_file_name = "libxtst6_2%3a1.2.3-1_amd64.deb"
  $libxtst6_package_name = "libxtst6"
  $libxrender1_file_name = "libxrender1_1%3a0.9.10-1_amd64.deb"
  $libxrender1_package_name = "libxrender1"
  $libxi6_file_name = "libxi6_2%3a1.7.9-1_amd64.deb"
  $libxi6_package_name = "libxi6"
  $libasound2_file_name = "libasound2_1.1.3-5ubuntu0.2_amd64.deb"
  $libasound2_package_name = "libasound2"
  $x11_common_file_name = "x11-common_1%3a7.7+19ubuntu7.1_all.deb"
  $x11_common_package_name = "x11-common"
  $libasound2_data_file_name = "libasound2-data_1.1.3-5ubuntu0.2_all.deb"
  $libasound2_data_package_name = "libasound2-data"

  file { "${java_common_file_name}":
    ensure => present,
    path   => "${local_install_dir}${java_common_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${java_common_file_name}",
  }
  package { "${java_common_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${java_common_file_name}",
    require  => [
      File["${java_common_file_name}"],
    ]
  }

  file { "${x11_common_file_name}":
    ensure => present,
    path   => "${local_install_dir}${x11_common_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${x11_common_file_name}",
  }
  package { "${x11_common_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${x11_common_file_name}",
    require  => [
      File["${x11_common_file_name}"],
    ]
  }

  file { "${libxtst6_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libxtst6_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libxtst6_file_name}",
  }
  package { "${libxtst6_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libxtst6_file_name}",
    require  => [
      File["${libxtst6_file_name}"],
      Package["${x11_common_package_name}"],
    ]
  }

  file { "${libxrender1_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libxrender1_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libxrender1_file_name}",
  }
  package { "${libxrender1_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libxrender1_file_name}",
    require  => [
      File["${libxrender1_file_name}"],
    ]
  }

  file { "${libxi6_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libxi6_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libxi6_file_name}",
  }
  package { "${libxi6_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libxi6_file_name}",
    require  => [
      File["${libxi6_file_name}"],
    ]
  }

  file { "${libasound2_data_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libasound2_data_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libasound2_data_file_name}",
  }
  package { "${libasound2_data_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libasound2_data_file_name}",
    require  => [
      File["${libasound2_data_file_name}"],
    ]
  }

  file { "${libasound2_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libasound2_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libasound2_file_name}",
  }
  package { "${libasound2_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libasound2_file_name}",
    require  => [
      File["${libasound2_file_name}"],
      Package["${libasound2_data_package_name}"],
    ]
  }
}