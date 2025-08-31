define certbot::ubuntu::bionic {

  $local_install_dir=$certbot::local_install_dir
  $puppet_file_dir=$certbot::puppet_file_dir

  include python3
  realize(Python3::Ubuntu::Bionic["virtual"])

  $certbot_file_name = "certbot_0.27.0-1~ubuntu18.04.1_all.deb"
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

  $python3_certbot_file_name = "python3-certbot_0.27.0-1~ubuntu18.04.1_all.deb"
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

  $python3_acme_file_name = "python3-acme_0.31.0-2~ubuntu18.04.1_all.deb"
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
      Package["python3-requests-toolbelt"]
    ]
  }

  $python3_requests_toolbelt_file_name = "python3-requests-toolbelt_0.8.0-1_all.deb"
  $python3_requests_toolbelt_package_name = "python3-requests-toolbelt"
  file { "${python3_requests_toolbelt_file_name}":
    ensure => present,
    path   => "${local_install_dir}${python3_requests_toolbelt_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${python3_requests_toolbelt_file_name}",
  }
  package { "${python3_requests_toolbelt_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${python3_requests_toolbelt_file_name}",
    require  => [
    File["${python3_requests_toolbelt_file_name}"],
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

define certbot::ubuntu::bionic::apache {
  $puppet_file_dir = "modules/certbot/"
  $local_install_path = "/etc/puppet/"
  $local_install_dir = "${local_install_path}installers/"

  $python_certbot_apache_file_name = "python-certbot-apache_0.23.0-1_all.deb"
  file { "${python_certbot_apache_file_name}":
    ensure => present,
    path   => "${local_install_dir}${python_certbot_apache_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${python_certbot_apache_file_name}",
  }
  package { "python-certbot-apache":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${python_certbot_apache_file_name}",
    require  => [
      File["${python_certbot_apache_file_name}"],
      Package["python3-certbot-apache"],
    ]
  }

  $python3_certbot_apache_file_name = "python3-certbot-apache_0.23.0-1_all.deb"
  file { "${python3_certbot_apache_file_name}":
    ensure => present,
    path   => "${local_install_dir}${python3_certbot_apache_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${python3_certbot_apache_file_name}",
  }
  package { "python3-certbot-apache":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${python3_certbot_apache_file_name}",
    require  => [
      File["${python3_certbot_apache_file_name}"],
      Package["python3-augeas"],
      # Package["apache2"],
      Package["certbot"],
      Package["python3-acme"],
      Package["python3-certbot"],
      Package["python3-mock"],
      Package["python3-zope.component"],
    ]
  }

  $python3_augeas_file_name = "python3-augeas_0.5.0-1_all.deb"
  file { "${python3_augeas_file_name}":
    ensure => present,
    path   => "${local_install_dir}${python3_augeas_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${python3_augeas_file_name}",
  }
  package { "python3-augeas":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${python3_augeas_file_name}",
    require  => [
      File["${python3_augeas_file_name}"],
    ]
  }
}

define certbot::ubuntu::bionic::apache::reinstall(
  $server_name = undef,
  $server_aliases = undef,
  $document_root = undef,
) {
  $apache_virtual_host_sites = "/etc/apache2/sites-available/"
  $certbox_home = "/etc/letsencrypt/"

  if ($server_name == undef) {
    fail("A virtual host is required to reinstall certbot certificates")
  }

  $domain_aliases = reduce($server_aliases) |$result, $alias|  { "${result} -d ${alias}"}

  # sudo?
  $reinstall_command = "certbot run \
-i apache \
-a webroot \
-d ${server_name} \
-d ${domain_aliases} \
-w ${document_root} \
--redirect \
--uir \
--hsts \
--reinstall"

  $virtual_host_ssl_config = "${server_name}-le-ssl.conf"
  exec { "Remove Apache SSL Configuration for ${server_name}":
    path => "/bin/",
    command => "rm ${apache_virtual_host_sites}${virtual_host_ssl_config}",
    onlyif => "/bin/ls -1 ${apache_virtual_host_sites} | grep ${virtual_host_ssl_config}",
    before => Exec["Reinstall SSL Configuration for ${server_name}"]
  }

  exec {"Reinstall SSL Configuration for ${server_name}":
    path => "/usr/bin/",
    command => "${reinstall_command}",
    onlyif => "/bin/ls -1 ${certbox_home}live/${server_name}",
  }
}