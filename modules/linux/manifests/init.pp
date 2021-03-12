class linux {}

class linux::ubuntu::xenial::deps {
  $local_install_path = "/etc/puppet/"
  $local_install_dir = "${local_install_path}installers/"
  $puppet_file_dir    = "modules/linux/"

  $libxi6_file_name = "libxi6_2%3a1.7.6-1_amd64.deb"
  $libxi6_package_name = "libxi6"
  $x11_common_file_name = "x11-common_1%3a7.7+13ubuntu3.1_all.deb"
  $x11_common_package_name = "x11-common"

  @file { "${libxi6_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libxi6_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libxi6_file_name}",
  }
  @package { "${libxi6_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libxi6_file_name}",
    require  => [
      File["${libxi6_file_name}"],
      Package["${x11_common_package_name}"],
    ]
  }

  @file { "${x11_common_file_name}":
    ensure => present,
    path   => "${local_install_dir}${x11_common_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${x11_common_file_name}",
  }
  @package { "${x11_common_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${x11_common_file_name}",
    require  => [
      File["${x11_common_file_name}"],
    ]
  }
}

class linux::ubuntu::bionic::deps {
  $local_install_path = "/etc/puppet/"
  $local_install_dir = "${local_install_path}installers/"
  $puppet_file_dir    = "modules/linux/"

  $x11_common_file_name = "x11-common_1%3a7.7+19ubuntu7.1_all.deb"
  $x11_common_package_name = "x11-common"
  $libxrender1_file_name = "libxrender1_1%3a0.9.10-1_amd64.deb"
  $libxrender1_package_name = "libxrender1"
  $libxi6_file_name = "libxi6_2%3a1.7.9-1_amd64.deb"
  $libxi6_package_name = "libxi6"

  $fontconfig_file_name = "fontconfig_2.12.6-0ubuntu2_amd64.deb"
  $fontconfig_package_name = "fontconfig"
  $fontconfig_config_file_name = "fontconfig-config_2.12.6-0ubuntu2_all.deb"
  $fontconfig_config_package_name = "fontconfig-config"
  $libfontconfig1_file_name = "libfontconfig1_2.12.6-0ubuntu2_amd64.deb"
  $libfontconfig1_package_name = "libfontconfig1"

  @file { "${x11_common_file_name}":
    ensure => present,
    path   => "${local_install_dir}${x11_common_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${x11_common_file_name}",
  }
  @package { "${x11_common_package_name}":
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
  @package { "${libxrender1_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libxrender1_file_name}",
    require  => [
      File["${libxrender1_file_name}"],
    ]
  }

  @file { "${libxi6_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libxi6_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libxi6_file_name}",
  }
  @package { "${libxi6_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libxi6_file_name}",
    require  => [
      File["${libxi6_file_name}"],
    ]
  }

  $fonts_liberation_file_name = "fonts-liberation_1%3a1.07.4-7~18.04.1_all.deb"
  $fonts_liberation_package_name = "fonts-liberation"
  @file { "${fonts_liberation_file_name}":
    ensure => present,
    path   => "${local_install_dir}${fonts_liberation_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${fonts_liberation_file_name}",
  }
  @package { "${fonts_liberation_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${fonts_liberation_file_name}",
    require  => [
      File["${fonts_liberation_file_name}"],
    ]
  }

  @file { "${fontconfig_file_name}":
    ensure => present,
    path   => "${local_install_dir}${fontconfig_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${fontconfig_file_name}",
  }
  @package { "${fontconfig_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${fontconfig_file_name}",
    require  => [
      File["${fontconfig_file_name}"],
      Package["${linux::ubuntu::bionic::deps::fontconfig_config_package_name}"],
      Package["${linux::ubuntu::bionic::deps::libfontconfig1_package_name}"],
    ]
  }

  @file { "${fontconfig_config_file_name}":
    ensure => present,
    path   => "${local_install_dir}${fontconfig_config_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${fontconfig_config_file_name}",
  }
  @package { "${fontconfig_config_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${fontconfig_config_file_name}",
    require  => [
      File["${fontconfig_config_file_name}"],
      Package["${linux::ubuntu::bionic::deps::fonts_liberation_package_name}"],
    ]
  }

  @file { "${libfontconfig1_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libfontconfig1_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libfontconfig1_file_name}",
  }
  @package { "${libfontconfig1_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libfontconfig1_file_name}",
    require  => [
      File["${libfontconfig1_file_name}"],
      Package["${fontconfig_config_package_name}"],
    ]
  }


}