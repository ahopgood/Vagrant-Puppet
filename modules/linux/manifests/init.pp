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