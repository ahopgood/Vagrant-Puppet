# Class: python
#
# This module manages patch
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class python {
  
  $local_install_path = "/etc/puppet/"
  $local_install_dir = "${local_install_path}installers/"
  $puppet_file_dir = "modules/${module_name}/"


  if (versioncmp("Ubuntu", "${operatingsystem}") == 0) {
    if (versioncmp ("16.04", "${operatingsystemmajrelease}") == 0){
      @python::ubuntu::xenial{"virtual":}
    } else {
      fail("${operatingsystem} version ${operatingsystemmajrelease} is not currently supported by the patch module")
    }
  } else {
    fail("${operatingsystem} is not currently supported by the patch module")
  }
}

define python::ubuntu::xenial {
  $puppet_file_dir=$python::puppet_file_dir
  $local_install_dir=$python::local_install_dir

  $python_file_name = "python_2.7.12-1~16.04_amd64.deb"
  file { "${python_file_name}":
    ensure => present,
    path   => "${local_install_dir}${python_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${python_file_name}",
  }

  package { "python":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${python_file_name}",
    require  => [
      File["${python_file_name}"],
      Package["python-minimal"],
      Package["libpython-stdlib"],
      Package["python2.7"],
    ]
  }

  $python_minimal_file_name = "python-minimal_2.7.12-1~16.04_amd64.deb"
  file { "${python_minimal_file_name}":
    ensure => present,
    path   => "${local_install_dir}${python_minimal_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${python_minimal_file_name}",
  }
  package { "python-minimal":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${python_minimal_file_name}",
    require  => [
      File["${python_minimal_file_name}"],
      Package["python2.7-minimal"],
    ]
  }

  $python2_7_minimal_file_name = "python2.7-minimal_2.7.12-1ubuntu0~16.04.8_amd64.deb"
  file { "${python2_7_minimal_file_name}":
    ensure => present,
    path   => "${local_install_dir}${python2_7_minimal_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${python2_7_minimal_file_name}",
  }
  package { "python2.7-minimal":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${python2_7_minimal_file_name}",
    require  => [
      File["${python2_7_minimal_file_name}"],
      Package["libpython2.7-minimal"]
    ]
  }

  $libpython2_7_minimal_file_name = "libpython2.7-minimal_2.7.12-1ubuntu0~16.04.8_amd64.deb"
  file { "${libpython2_7_minimal_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libpython2_7_minimal_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libpython2_7_minimal_file_name}",
  }
  package { "libpython2.7-minimal":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libpython2_7_minimal_file_name}",
    require  => [
      File["${libpython2_7_minimal_file_name}"],
    ]
  }

  $libpython_stdlib_file_name = "libpython-stdlib_2.7.12-1~16.04_amd64.deb"
  file { "${libpython_stdlib_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libpython_stdlib_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libpython_stdlib_file_name}",
  }
  package { "libpython-stdlib":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libpython_stdlib_file_name}",
    require  => [
      File["${libpython_stdlib_file_name}"],
      Package["libpython2.7-stdlib"],
    ]
  }

  $python2_7_file_name = "python2.7_2.7.12-1ubuntu0~16.04.8_amd64.deb"
  file { "${python2_7_file_name}":
    ensure => present,
    path   => "${local_install_dir}${python2_7_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${python2_7_file_name}",
  }
  package { "python2.7":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${python2_7_file_name}",
    require  => [
      File["${python2_7_file_name}"],
      Package["libpython2.7-stdlib"],
    ]
  }

  $libpython2_7_stdlib_file_name = "libpython2.7-stdlib_2.7.12-1ubuntu0~16.04.8_amd64.deb"
  file { "${libpython2_7_stdlib_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libpython2_7_stdlib_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libpython2_7_stdlib_file_name}",
  }
  package { "libpython2.7-stdlib":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libpython2_7_stdlib_file_name}",
    require  => [
      File["${libpython2_7_stdlib_file_name}"],
      Package["libpython2.7-minimal"],
    ]
  }
}