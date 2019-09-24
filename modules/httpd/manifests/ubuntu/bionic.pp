define httpd::ubuntu::bionic {

  # sudo puppet apply --modulepath=/etc/puppet/modules /vagrant/tests/httpd.pp
  $puppet_file_dir=$httpd::puppet_file_dir
  $local_install_dir=$httpd::local_install_dir

  ufw{"open port 80":
    port => "80",
    isTCP => true
  }

  $apache2_file_name = "apache2_2.4.41-1+ubuntu18.04.1+deb.sury.org+5_amd64.deb"
  file { "${apache2_file_name}":
    ensure => present,
    path   => "${local_install_dir}${apache2_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${apache2_file_name}",
  }
  package { "apache2":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${apache2_file_name}",
    require  => [
      File["${apache2_file_name}"],
      Package["apache2-bin"],
      Package["apache2-data"],
      Package["apache2-utils"],
    ],
    notify => Service["apache2"]
  }

  service {
    "apache2":
      require => Package["apache2"],
      ensure => running,
      enable => true,
  }

  $apache2_bin_file_name = "apache2-bin_2.4.41-1+ubuntu18.04.1+deb.sury.org+5_amd64.deb"
  file { "${apache2_bin_file_name}":
    ensure => present,
    path   => "${local_install_dir}${apache2_bin_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${apache2_bin_file_name}",
  }
  package { "apache2-bin":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${apache2_bin_file_name}",
    require  => [
      File["${apache2_bin_file_name}"],
      Package["libapr1"],
      Package["libaprutil1"],
      Package["libaprutil1-dbd-sqlite3"],
      Package["libaprutil1-ldap"],
      Package["libbrotli1"],
      Package["libcurl4"],
      Package["libjansson4"],
      Package["liblua5.2-0"],
      Package["libssl1.1"],
      Package["libldap-2.4-2"],
    ]
  }

  $libapr1_file_name = "libapr1_1.6.3-2_amd64.deb"
  file { "${libapr1_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libapr1_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libapr1_file_name}",
  }
  package { "libapr1":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libapr1_file_name}",
    require  => [
      File["${libapr1_file_name}"],
    ]
  }

  $libaprutil1_file_name = "libaprutil1_1.6.1-5+ubuntu18.04.1+deb.sury.org+1_amd64.deb"
  file { "${libaprutil1_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libaprutil1_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libaprutil1_file_name}",
  }
  package { "libaprutil1":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libaprutil1_file_name}",
    require  => [
      File["${libaprutil1_file_name}"],
      Package["libapr1"],
      Package["libssl1.1"],
    ]
  }

  $libaprutil1_dbd_sqlite3_file_name = "libaprutil1-dbd-sqlite3_1.6.1-5+ubuntu18.04.1+deb.sury.org+1_amd64.deb"
  file { "${libaprutil1_dbd_sqlite3_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libaprutil1_dbd_sqlite3_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libaprutil1_dbd_sqlite3_file_name}",
  }
  package { "libaprutil1-dbd-sqlite3":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libaprutil1_dbd_sqlite3_file_name}",
    require  => [
      File["${libaprutil1_dbd_sqlite3_file_name}"],
      Package["libaprutil1"],
    ]
  }
  $libaprutil1_ldap_file_name = "libaprutil1-ldap_1.6.1-5+ubuntu18.04.1+deb.sury.org+1_amd64.deb"
  file { "${libaprutil1_ldap_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libaprutil1_ldap_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libaprutil1_ldap_file_name}",
  }
  package { "libaprutil1-ldap":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libaprutil1_ldap_file_name}",
    require  => [
      File["${libaprutil1_ldap_file_name}"],
      Package["libaprutil1"],
    ]
  }
  $libbrotli1_file_name = "libbrotli1_1.0.7-2+ubuntu18.04.1+deb.sury.org+1_amd64.deb"
  file { "${libbrotli1_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libbrotli1_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libbrotli1_file_name}",
  }
  package { "libbrotli1":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libbrotli1_file_name}",
    require  => [
      File["${libbrotli1_file_name}"],
    ]
  }

  $libcurl4_file_name = "libcurl4_7.58.0-2ubuntu3.8_amd64.deb"
  file { "${libcurl4_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libcurl4_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libcurl4_file_name}",
  }
  package { "libcurl4":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libcurl4_file_name}",
    require  => [
      File["${libcurl4_file_name}"],
      Package["libldap-2.4-2"],
      Package["libssl1.1"],
    ]
  }

  $libjansson4_file_name = "libjansson4_2.11-1_amd64.deb"
  file { "${libjansson4_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libjansson4_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libjansson4_file_name}",
  }
  package { "libjansson4":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libjansson4_file_name}",
    require  => [
      File["${libjansson4_file_name}"],
    ]
  }

  $liblua5_2_0_file_name = "liblua5.2-0_5.2.4-1.1build1_amd64.deb"
  file { "${liblua5_2_0_file_name}":
    ensure => present,
    path   => "${local_install_dir}${liblua5_2_0_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${liblua5_2_0_file_name}",
  }
  package { "liblua5.2-0":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${liblua5_2_0_file_name}",
    require  => [
      File["${liblua5_2_0_file_name}"],
    ]
  }

  $libssl1_1_file_name = "libssl1.1_1.1.1c-1+ubuntu18.04.1+deb.sury.org+1_amd64.deb"
  file { "${libssl1_1_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libssl1_1_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libssl1_1_file_name}",
  }
  package { "libssl1.1":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libssl1_1_file_name}",
    require  => [
      File["${libssl1_1_file_name}"],
    ]
  }

  $libldap_2_4_2_file_name = "libldap-2.4-2_2.4.45+dfsg-1ubuntu1.4_amd64.deb"
  file { "${libldap_2_4_2_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libldap_2_4_2_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libldap_2_4_2_file_name}",
  }
  package { "libldap-2.4-2":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libldap_2_4_2_file_name}",
    require  => [
      File["${libldap_2_4_2_file_name}"],
    ]
  }

  $apache2_data_file_name = "apache2-data_2.4.41-1+ubuntu18.04.1+deb.sury.org+5_all.deb"
  file { "${apache2_data_file_name}":
    ensure => present,
    path   => "${local_install_dir}${apache2_data_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${apache2_data_file_name}",
  }
  package { "apache2-data":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${apache2_data_file_name}",
    require  => [
      File["${apache2_data_file_name}"],
    ]
  }

  $apache2_utils_file_name = "apache2-utils_2.4.41-1+ubuntu18.04.1+deb.sury.org+5_amd64.deb"
  file { "${apache2_utils_file_name}":
    ensure => present,
    path   => "${local_install_dir}${apache2_utils_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${apache2_utils_file_name}",
  }
  package { "apache2-utils":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${apache2_utils_file_name}",
    require  => [
      File["${apache2_utils_file_name}"],
      Package["libapr1"],
      Package["libaprutil1"],
      Package["libssl1.1"],
    ]
  }

}