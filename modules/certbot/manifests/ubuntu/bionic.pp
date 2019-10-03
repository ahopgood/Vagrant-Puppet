define certbot::ubuntu::bionic {

  $local_install_dir=$certbot::local_install_dir
  $puppet_file_dir=$certbot::puppet_file_dir

  include python3
  realize(Python3::Ubuntu::Bionic["virtual"])

  $certbot_file_name = "certbot_0.23.0-1_all.deb"
  file { "${certbot_file_name}":
    ensure => present,
    path   => "${local_install_dir}${certbot_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${certbot_file_name}",
  }
  package { "certbot":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${certbot_file_name}",
    require  => [
      File["${certbot_file_name}"],
      Package["python3-certbot"],
      Package["python3"]
    ]
  }

  $python3_certbot_file_name = "python3-certbot_0.23.0-1_all.deb"
  file { "${python3_certbot_file_name}":
    ensure => present,
    path   => "${local_install_dir}${python3_certbot_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${python3_certbot_file_name}",
  }
  package { "python3-certbot":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${python3_certbot_file_name}",
    require  => [
      File["${python3_certbot_file_name}"],
      Package["python3"],
      Package["python3-acme"],
      Package["python3-josepy"],
      Package["python3-configargparse"],
      Package["python3-mock"],
      Package["python3-parsedatetime"],
      Package["python3-rfc3339"],
      Package["python3-tz"],
      Package["python3-zope.component"],
    ]
  }

  $python3_acme_file_name = "python3-acme_0.22.2-1ubuntu0.1_all.deb"
  file { "${python3_acme_file_name}":
    ensure => present,
    path   => "${local_install_dir}${python3_acme_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${python3_acme_file_name}",
  }
  package { "python3-acme":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${python3_acme_file_name}",
    require  => [
      File["${python3_acme_file_name}"],
      Package["python3-josepy"],
      Package["python3-mock"],
      Package["python3-rfc3339"],
      Package["python3-tz"],
    ]
  }

  $python3_josepy_file_name = "python3-josepy_1.1.0-1_all.deb"
  file { "${python3_josepy_file_name}":
    ensure => present,
    path   => "${local_install_dir}${python3_josepy_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${python3_josepy_file_name}",
  }
  package { "python3-josepy":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${python3_josepy_file_name}",
    require  => [
      File["${python3_josepy_file_name}"],
    ]
  }

  $python3_mock_file_name = "python3-mock_2.0.0-3_all.deb"
  file { "${python3_mock_file_name}":
    ensure => present,
    path   => "${local_install_dir}${python3_mock_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${python3_mock_file_name}",
  }
  package { "python3-mock":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${python3_mock_file_name}",
    require  => [
      File["${python3_mock_file_name}"],
      Package["python3-pbr"],
    ]
  }

  $python3_rfc3339_file_name = "python3-rfc3339_1.0-4_all.deb"
  file { "${python3_rfc3339_file_name}":
    ensure => present,
    path   => "${local_install_dir}${python3_rfc3339_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${python3_rfc3339_file_name}",
  }
  package { "python3-rfc3339":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${python3_rfc3339_file_name}",
    require  => [
      File["${python3_rfc3339_file_name}"],
      Package["python3-tz"],
    ]
  }

  $python3_tz_file_name = "python3-tz_2018.3-2_all.deb"
  file { "${python3_tz_file_name}":
    ensure => present,
    path   => "${local_install_dir}${python3_tz_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${python3_tz_file_name}",
  }
  package { "python3-tz":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${python3_tz_file_name}",
    require  => [
      File["${python3_tz_file_name}"],
    ]
  }

  $python3_pbr_file_name = "python3-pbr_3.1.1-3ubuntu3_all.deb"
  file { "${python3_pbr_file_name}":
    ensure => present,
    path   => "${local_install_dir}${python3_pbr_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${python3_pbr_file_name}",
  }
  package { "python3-pbr":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${python3_pbr_file_name}",
    require  => [
      File["${python3_pbr_file_name}"],
    ]
  }

  $python3_configargparse_file_name = "python3-configargparse_0.11.0-1_all.deb"
  file { "${python3_configargparse_file_name}":
    ensure => present,
    path   => "${local_install_dir}${python3_configargparse_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${python3_configargparse_file_name}",
  }
  package { "python3-configargparse":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${python3_configargparse_file_name}",
    require  => [
      File["${python3_configargparse_file_name}"],
    ]
  }

  $python3_parsedatetime_file_name = "python3-parsedatetime_2.4-2_all.deb"
  file { "${python3_parsedatetime_file_name}":
    ensure => present,
    path   => "${local_install_dir}${python3_parsedatetime_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${python3_parsedatetime_file_name}",
  }
  package { "python3-parsedatetime":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${python3_parsedatetime_file_name}",
    require  => [
      File["${python3_parsedatetime_file_name}"],
      Package["python3-future"],
    ]
  }

  $python3_future_file_name = "python3-future_0.15.2-4ubuntu2_all.deb"
  file { "${python3_future_file_name}":
    ensure => present,
    path   => "${local_install_dir}${python3_future_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${python3_future_file_name}",
  }
  package { "python3-future":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${python3_future_file_name}",
    require  => [
      File["${python3_future_file_name}"],
      Package["python3-lib2to3"],
    ]
  }

  $python3_lib2to3_file_name = "python3-lib2to3_3.6.8-1~18.04_all.deb"
  file { "${python3_lib2to3_file_name}":
    ensure => present,
    path   => "${local_install_dir}${python3_lib2to3_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${python3_lib2to3_file_name}",
  }
  package { "python3-lib2to3":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${python3_lib2to3_file_name}",
    require  => [
      File["${python3_lib2to3_file_name}"],
    ]
  }

  $python3_zope_component_file_name = "python3-zope.component_4.3.0-1_all.deb"
  file { "${python3_zope_component_file_name}":
    ensure => present,
    path   => "${local_install_dir}${python3_zope_component_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${python3_zope_component_file_name}",
  }
  package { "python3-zope.component":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${python3_zope_component_file_name}",
    require  => [
      File["${python3_zope_component_file_name}"],
      Package["python3-zope.event"],
      Package["python3-zope.hookable"],
    ]
  }

  $python3_zope_event_file_name = "python3-zope.event_4.2.0-1_all.deb"
  file { "${python3_zope_event_file_name}":
    ensure => present,
    path   => "${local_install_dir}${python3_zope_event_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${python3_zope_event_file_name}",
  }
  package { "python3-zope.event":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${python3_zope_event_file_name}",
    require  => [
      File["${python3_zope_event_file_name}"],
    ]
  }

  $python3_zope_hookable_file_name = "python3-zope.hookable_4.0.4-4build4_amd64.deb"
  file { "${python3_zope_hookable_file_name}":
    ensure => present,
    path   => "${local_install_dir}${python3_zope_hookable_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${python3_zope_hookable_file_name}",
  }
  package { "python3-zope.hookable":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${python3_zope_hookable_file_name}",
    require  => [
      File["${python3_zope_hookable_file_name}"],
    ]
  }

}