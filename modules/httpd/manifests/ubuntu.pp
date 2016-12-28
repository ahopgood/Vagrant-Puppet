class httpd::ubuntu (
  $major_version = undef,
  $minor_version = undef,
  $patch_version = undef,
){
  
  $puppet_file_dir = "modules/httpd/${operatingsystem}/${operatingsystemmajrelease}/"
  $local_install_dir = "${local_install_path}installers/"
  
  $platform = "amd64"
  $ubuntu_version = "-2ubuntu2.1_"

  $libapr1_file = "libapr1_1.5.2-3_${platform}.deb"
  file{"libapr1-file":
    ensure => present,
    path => "${local_install_dir}${libapr1_file}",
    source => "puppet:///${puppet_file_dir}${libapr1_file}"
  }

  package{"libapr":
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
      Package["libapr"]
      ]
  }

  
#  file{"apache2":
#  }
    
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

}