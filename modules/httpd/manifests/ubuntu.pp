class httpd::ubuntu (
  $major_version = undef,
  $minor_version = undef,
  $patch_version = undef,
){
  $local_install_dir = "${local_install_path}installers/"

  ufw{"open port 80":
    port => "80",
    isTCP => true 
  }

  $apache_version = "${major_version}.${minor_version}.${patch_version}"

  notify{"${apache_version}":}

  $platform = "amd64"
  if (versioncmp("${apache_version}","2.4.12") == 0) {
    $puppet_file_dir = "modules/httpd/${operatingsystem}/${operatingsystemmajrelease}/"
    $ubuntu_version = "-2ubuntu2.1_"

  } elsif (versioncmp("${apache_version}","2.4.39") == 0) {
    $puppet_file_dir = "modules/httpd/${operatingsystem}/${operatingsystemmajrelease}/${major_version}.${minor_version}.${patch_version}/"
    $ubuntu_version = "+ubuntu16.04.1+deb.sury.org+"

    $libbrotli_package = $apache_version ? {
      "2.4.12" => undef,
      "2.4.39" => "libbrotli1",
    }
    $libbrotli_version = $apache_version ? {
      "2.4.12" => undef,
      "2.4.39" => "1.0.5-1${ubuntu_version}2",
    }
    $libbrotli_file = "${libbrotli_package}_${libbrotli_version}_${platform}.deb"
    file{"libbrotli-file":
      ensure => present,
      path => "${local_install_dir}${libbrotli_file}",
      source => "puppet:///${puppet_file_dir}${libbrotli_file}"
    }

    package{"${libbrotli_package}":
      provider => "dpkg",
      ensure => installed,
      source => "${local_install_dir}${libbrotli_file}",
      require => File["libbrotli-file"]
    }
    # libcurl3
    $libcurl3_package = $apache_version ? {
      "2.4.12" => undef,
      "2.4.39" => "libcurl3",
    }
    $libcurl3_version = $apache_version ? {
      "2.4.12" => undef,
      "2.4.39" => "7.47.0-1ubuntu2.13",
    }
    $libcurl3_file = "${libcurl3_package}_${libcurl3_version}_${platform}.deb"
    file{"libcurl3-file":
      ensure => present,
      path => "${local_install_dir}${libcurl3_file}",
      source => "puppet:///${puppet_file_dir}${libcurl3_file}"
    }

    package{"${libcurl3_package}":
      provider => "dpkg",
      ensure => installed,
      source => "${local_install_dir}${libcurl3_file}",
      require => File["libcurl3-file"]
    }

    $libjansson4_package = $apache_version ? {
      "2.4.12" => undef,
      "2.4.39" => "libjansson4",
    }
    $libjansson4_version = $apache_version ? {
      "2.4.12" => undef,
      "2.4.39" => "2.7-3ubuntu0.1",
    }
    $libjansson4_file = "${libjansson4_package}_${libjansson4_version}_${platform}.deb"
    file{"libjansson4-file":
      ensure => present,
      path => "${local_install_dir}${libjansson4_file}",
      source => "puppet:///${puppet_file_dir}${libjansson4_file}"
    }

    package{"${libjansson4_package}":
      provider => "dpkg",
      ensure => installed,
      source => "${local_install_dir}${libjansson4_file}",
      require => File["libjansson4-file"]
    }

    $libnghttp2_14_package = $apache_version ? {
      "2.4.12" => undef,
      "2.4.39" => "libnghttp2-14",
    }
    $libnghttp2_14_version = $apache_version ? {
      "2.4.12" => undef,
      "2.4.39" => "1.29.0-1${ubuntu_version}1",
    }
    $libnghttp2_14_file = "${libnghttp2_14_package}_${libnghttp2_14_version}_${platform}.deb"
    file{"libnghttp2_14-file":
      ensure => present,
      path => "${local_install_dir}${libnghttp2_14_file}",
      source => "puppet:///${puppet_file_dir}${libnghttp2_14_file}"
    }

    package{"${libnghttp2_14_package}":
      provider => "dpkg",
      ensure => installed,
      source => "${local_install_dir}${libnghttp2_14_file}",
      require => File["libnghttp2_14-file"]
    }

    $libssl1_1_package = $apache_version ? {
      "2.4.12" => undef,
      "2.4.39" => "libssl1.1",
    }
    $libssl1_1_version = $apache_version ? {
      "2.4.12" => undef,
      "2.4.39" => "1.1.1c-1${ubuntu_version}1",
    }
    $libssl1_1_file = "${libssl1_1_package}_${libssl1_1_version}_${platform}.deb"
    file{"libssl1_1-file":
      ensure => present,
      path => "${local_install_dir}${libssl1_1_file}",
      source => "puppet:///${puppet_file_dir}${libssl1_1_file}"
    }

    package{"${libssl1_1_package}":
      provider => "dpkg",
      ensure => installed,
      source => "${local_install_dir}${libssl1_1_file}",
      require => File["libssl1_1-file"]
    }
  }

  $liblua_package = $apache_version ? {
    "2.4.12" => "liblua5.1-0",
    "2.4.39" => "liblua5.2-0",
  }
  $liblua_version = $apache_version ? {
    "2.4.12" => "5.1.5-8",
    "2.4.39" => "5.2.4-1ubuntu1",
  }
  $liblua_file = "${liblua_package}_${liblua_version}_${platform}.deb"

  file{"liblua-file":
    ensure => present,
    path => "${local_install_dir}${liblua_file}",
    source => "puppet:///${puppet_file_dir}${liblua_file}"
  }

  package{"${liblua_package}":
    provider => "dpkg",
    ensure => installed,
    source => "${local_install_dir}${liblua_file}",
    require => File["liblua-file"]
  }

  $libaprutil_package = $apache_version ? {
    "2.4.12" => "libaprutil1",
    "2.4.39" => "libaprutil1",
  }
  $libaprutil_version = $apache_version ? {
    "2.4.12" => "1.5.4-1",
    "2.4.39" => "1.6.0-2${ubuntu_version}2",
  }
  $libaprutil_file = "${libaprutil_package}_${libaprutil_version}_${platform}.deb"
  file{"libaprutil-file":
    ensure => present,
    path => "${local_install_dir}${libaprutil_file}",
    source => "puppet:///${puppet_file_dir}${libaprutil_file}"
  }

  $libapr1_package = $apache_version ? {
    "2.4.12" => "libapr1",
    "2.4.39" => "libapr1",
  }
  $libapr1_version = $apache_version ? {
    "2.4.12" => "1.5.2-3",
    "2.4.39" => "1.6.2-1${ubuntu_version}2",
  }
  $libapr1_file = "${libapr1_package}_${libapr1_version}_${platform}.deb"
  file{"libapr1-file":
    ensure => present,
    path => "${local_install_dir}${libapr1_file}",
    source => "puppet:///${puppet_file_dir}${libapr1_file}"
  }

  package{"${libapr1_package}":
    provider => "dpkg",
    ensure => installed,
    source => "${local_install_dir}${libapr1_file}",
    require => File["libapr1-file"]
  }

  $libaprutil_deps = $apache_version ? {
    "2.4.12" => [
      File["libaprutil-file"]
    ],
    "2.4.39" => [
      File["libaprutil-file"],
      Package["${libapr1_package}"],
      Package["${libssl1_1_package}"]
    ],
  }
  package{"${libaprutil_package}":
    provider => "dpkg",
    ensure => installed,
    source => "${local_install_dir}${libaprutil_file}",
    require => $libaprutil_deps
  }

  $libaprutilsqllite3_package = $apache_version ? {
    "2.4.12" => "libaprutil1-dbd-sqlite3",
    "2.4.39" => "libaprutil1-dbd-sqlite3"
  }
  $libaprutilsqllite3_version = $apache_version ? {
    "2.4.12" => "1.5.4-1_",
    "2.4.39" => "1.6.0-2${ubuntu_version}2_"

  }
  $libaprutilsqlite3_file = "${libaprutilsqllite3_package}_${libaprutilsqllite3_version}${platform}.deb"
  file{"libaprutilsqlite3-file":
    ensure => present,
    path => "${local_install_dir}${libaprutilsqlite3_file}",
    source => "puppet:///${puppet_file_dir}${libaprutilsqlite3_file}"
  }

  package{"${libaprutilsqllite3_package}":
    provider => "dpkg",
    ensure => installed,
    source => "${local_install_dir}${libaprutilsqlite3_file}",
    require => [File["libaprutilsqlite3-file"], Package["${libaprutil_package}"]]
  }

  $libaprutilldap_package = "libaprutil1-ldap"
  $libaprutilldap_version = $apache_version ? {
    "2.4.12" => "1.5.4-1",
    "2.4.39" => "1.6.0-2${ubuntu_version}2"
  }
  $libaprutilldap_file = "libaprutil1-ldap_${libaprutilldap_version}_${platform}.deb"
  file{"libaprutilldap-file":
    ensure => present,
    path => "${local_install_dir}${libaprutilldap_file}",
    source => "puppet:///${puppet_file_dir}${libaprutilldap_file}"
  }

  package { "${libaprutilldap_package}":
    provider => "dpkg",
    ensure   => installed,
    source   => "${local_install_dir}${libaprutilldap_file}",
    require  => [File["libaprutilldap-file"],
      Package["${libaprutil_package}"]
    ]
  }

  $apache_bin_file = $apache_version ? {
    "2.4.12" => "apache2-bin_${major_version}.${minor_version}.${patch_version}${ubuntu_version}${platform}.deb",
    "2.4.39" => "apache2-bin_${major_version}.${minor_version}.${patch_version}-1${ubuntu_version}1_${platform}.deb",
  }
  file{"apache2-bin-file":
    ensure => present,
    path => "${local_install_dir}${apache_bin_file}",
    source => "puppet:///${puppet_file_dir}${apache_bin_file}"
  }

  $apache_bin_deps = $apache_version ? {
    "2.4.12" => [File["apache2-bin-file"],
      Package["${libapr1_package}"],
      Package["${libaprutil_package}"],
      Package["${libaprutilldap_package}"],
      Package["${liblua_package}"],
      Package["${libaprutilsqllite3_package}"]],
    "2.4.39" => [File["apache2-bin-file"],
      Package["${libapr1_package}"],
      Package["${libaprutil_package}"],
      Package["${liblua_package}"],
      Package["${libaprutilsqllite3_package}"],
      Package["${libaprutilldap_package}"],
      Package["${libbrotli_package}"],
      Package["${libcurl3_package}"],
      Package["${libjansson4_package}"],
      Package["${libnghttp2_14_package}"]
    ]
  }

  package{"apache2-bin":
    provider => "dpkg",
    ensure => installed,
    source => "${local_install_dir}${apache_bin_file}",
    require => $apache_bin_deps
  }

  $apache2_utils_file = $apache_version ? {
    "2.4.12" => "apache2-utils_${major_version}.${minor_version}.${patch_version}${ubuntu_version}${platform}.deb",
    "2.4.39" => "apache2-utils_${major_version}.${minor_version}.${patch_version}-1${ubuntu_version}1_${platform}.deb",
  }
  file{"apache2-utils-file":
    ensure => present,
    path => "${local_install_dir}${apache2_utils_file}",
    source => "puppet:///${puppet_file_dir}${apache2_utils_file}"
  }

  $apache2_utils_deps = $apache_version ? {
    "2.4.12" => [File["apache2-utils-file"],
      Package["${libapr1_package}"],
      Package["${libaprutil_package}"]
    ],
    "2.4.39" => [File["apache2-utils-file"],
      Package["${libapr1_package}"],
      Package["${libaprutil_package}"],
      Package["${libssl1_1_package}"]
    ],
  }

  package{"apache2-utils":
    provider => "dpkg",
    ensure => installed,
    source => "${local_install_dir}${apache2_utils_file}",
    require => $apache2_utils_deps
  }

  $apache2_data_file = $apache_version ? {
    "2.4.12" => "apache2-data_${major_version}.${minor_version}.${patch_version}${ubuntu_version}all.deb",
    "2.4.39" => "apache2-data_${major_version}.${minor_version}.${patch_version}-1${ubuntu_version}1_all.deb",
  }
  file{"apache2-data-file":
    ensure => present,
    path => "${local_install_dir}${apache2_data_file}",
    source => "puppet:///${puppet_file_dir}${apache2_data_file}"
  }

  package{"apache2-data":
    provider => "dpkg",
    ensure => installed,
    source => "${local_install_dir}${apache2_data_file}",
    require => [File["apache2-data-file"],]
  }

  $apache2_file = $apache_version ? {
    "2.4.12" => "apache2_${major_version}.${minor_version}.${patch_version}${ubuntu_version}${platform}.deb",
    "2.4.39" => "apache2_${major_version}.${minor_version}.${patch_version}-1${ubuntu_version}1_${platform}.deb",
  }
  file{"apache2-file":
    ensure => present,
    path => "${local_install_dir}${apache2_file}",
    source => "puppet:///${puppet_file_dir}${apache2_file}"
  }

  package{"apache2":
    provider => "dpkg",
    ensure => installed,
    source => "${local_install_dir}${apache2_file}",
    require => [File["apache2-file"],
      Package["apache2-bin"],
      Package["apache2-utils"],
      Package["apache2-data"]],
    notify => Service["apache2"]
  }

   service {
    "apache2":
    require => Package["apache2"],
    ensure => running,
    enable => true,
  }
  
  
   
}
#Unpacking apache2 (2.4.12-2ubuntu2.1) ...
#dpkg: dependency problems prevent configuration of apache2:
# apache2 depends on apache2-bin (= 2.4.12-2ubuntu2.1); however:
#  Package apache2-bin is not installed.
# apache2 depends on apache2-utils (>= 2.4); however:
#  Package apache2-utils is not installed.
# apache2 depends on apache2-data (= 2.4.12-2ubuntu2.1); however:
#  Package apache2-data is not installed.



/**
 * Unpacking apache2-bin (2.4.12-2ubuntu2.1) ...
dpkg: dependency problems prevent configuration of apache2-bin:
 apache2-bin depends on libapr1 (>= 1.5.0); however:
  Package libapr1 is not installed.
 apache2-bin depends on libaprutil1 (>= 1.5.0); however:
  Package libaprutil1 is not installed.
 apache2-bin depends on libaprutil1-dbd-sqlite3 | libaprutil1-dbd-mysql | libaprutil1-dbd-odbc | libaprutil1-dbd-pgsql | libaprutil1-dbd-freetds; however:
  Package libaprutil1-dbd-sqlite3 is not installed.
  Package libaprutil1-dbd-mysql is not installed.
  Package libaprutil1-dbd-odbc is not installed.
  Package libaprutil1-dbd-pgsql is not installed.
  Package libaprutil1-dbd-freetds is not installed.
 apache2-bin depends on libaprutil1-ldap; however:
  Package libaprutil1-ldap is not installed.
 apache2-bin depends on liblua5.1-0; however:
  Package liblua5.1-0 is not installed.
 
 */
/*
 * Unpacking apache2 (2.4.12-2ubuntu2.1) ...
dpkg: dependency problems prevent configuration of apache2:
 apache2 depends on apache2-utils (>= 2.4); however:
  Package apache2-utils is not installed.
 apache2 depends on apache2-data (= 2.4.12-2ubuntu2.1); however:
  Package apache2-data is not installed.
 
 */