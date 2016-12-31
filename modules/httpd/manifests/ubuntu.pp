class httpd::ubuntu (
  $major_version = undef,
  $minor_version = undef,
  $patch_version = undef,
){
  
  $puppet_file_dir = "modules/httpd/${operatingsystem}/${operatingsystemmajrelease}/"
  $local_install_dir = "${local_install_path}installers/"
  
  ufw{"open port 80": 
    port => "80",
    isTCP => true 
  }
  
  $platform = "amd64"
  $ubuntu_version = "-2ubuntu2.1_"
  
  $liblua_file = "liblua5.1-0_5.1.5-8_${platform}.deb"
  file{"liblua-file":
    ensure => present,
    path => "${local_install_dir}${liblua_file}",
    source => "puppet:///${puppet_file_dir}${liblua_file}"
  }

  package{"liblua":
    provider => "dpkg",
    ensure => installed,
    source => "${local_install_dir}${liblua_file}",
    require => File["liblua-file"]
  }

  $libaprutilsqlite3_file = "libaprutil1-dbd-sqlite3_1.5.4-1_${platform}.deb"
  file{"libaprutilsqlite3-file":
    ensure => present,
    path => "${local_install_dir}${libaprutilsqlite3_file}",
    source => "puppet:///${puppet_file_dir}${libaprutilsqlite3_file}"
  }

  package{"libaprutilsqlite3":
    provider => "dpkg",
    ensure => installed,
    source => "${local_install_dir}${libaprutilsqlite3_file}",
    require => [File["libaprutilsqlite3-file"], Package["libaprutil"]]
  }

  $libaprutilldap_file = "libaprutil1-ldap_1.5.4-1_${platform}.deb"
  file{"libaprutilldap-file":
    ensure => present,
    path => "${local_install_dir}${libaprutilldap_file}",
    source => "puppet:///${puppet_file_dir}${libaprutilldap_file}"
  }

  package{"libaprutilldap":
    provider => "dpkg",
    ensure => installed,
    source => "${local_install_dir}${libaprutilldap_file}",
    require => File["libaprutilldap-file"]
  }

  $libaprutil_file = "libaprutil1_1.5.4-1_${platform}.deb"
  file{"libaprutil-file":
    ensure => present,
    path => "${local_install_dir}${libaprutil_file}",
    source => "puppet:///${puppet_file_dir}${libaprutil_file}"
  }

  package{"libaprutil":
    provider => "dpkg",
    ensure => installed,
    source => "${local_install_dir}${libaprutil_file}",
    require => File["libaprutil-file"]
  }

  $libapr1_file = "libapr1_1.5.2-3_${platform}.deb"
  file{"libapr1-file":
    ensure => present,
    path => "${local_install_dir}${libapr1_file}",
    source => "puppet:///${puppet_file_dir}${libapr1_file}"
  }

  package{"libapr1":
    provider => "dpkg",
    ensure => installed,
    source => "${local_install_dir}${libapr1_file}",
    require => File["libapr1-file"]
  }
  
  $apache_bin_file = "apache2-bin_${major_version}.${minor_version}.${patch_version}${ubuntu_version}${platform}.deb"
  file{"apache2-bin-file":
    ensure => present,
    path => "${local_install_dir}${apache_bin_file}",
    source => "puppet:///${puppet_file_dir}${apache_bin_file}"
  }

  package{"apache2-bin":
    provider => "dpkg",
    ensure => installed,
    source => "${local_install_dir}${apache_bin_file}",
    require => [File["apache2-bin-file"],
      Package["libapr1"],
      Package["libaprutil"],
      Package["libaprutilldap"],
      Package["liblua"],
      Package["libaprutilsqlite3"]]
  }

  $apache2_utils_file = "apache2-utils_${major_version}.${minor_version}.${patch_version}${ubuntu_version}${platform}.deb"
  file{"apache2-utils-file":
    ensure => present,
    path => "${local_install_dir}${apache2_utils_file}",
    source => "puppet:///${puppet_file_dir}${apache2_utils_file}"
  }

  package{"apache2-utils":
    provider => "dpkg",
    ensure => installed,
    source => "${local_install_dir}${apache2_utils_file}",
    require => [File["apache2-utils-file"],
      Package["libapr1"],
      Package["libaprutil"]
    ]
  }
  
  $apache2_data_file = "apache2-data_${major_version}.${minor_version}.${patch_version}${ubuntu_version}all.deb"
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

  $apache2_file = "apache2_${major_version}.${minor_version}.${patch_version}${ubuntu_version}${platform}.deb"
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
    enable => true
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