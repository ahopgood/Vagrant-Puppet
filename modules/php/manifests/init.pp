# Class: php
#
# This module manages php
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class php (
) {
  notify{"PHP Module running":}
  
  
  
  Class["mysql"]
  ->
  Class["php"]
  contain 'httpd'
  
  $puppet_file_dir = "modules/${module_name}/"
  $local_install_dir = "${local_install_path}installers/"

  if (versioncmp("CentOS", "${operatingsystem}") == 0){
    $provider = "rpm"
    if (versioncmp("7", "${operatingsystemmajrelease}") == 0){
      $major_version = '5'
      $minor_version = '4'
      $patch_version = '16'
      $platform = "el7"
      $os_specific = ".${platform}_1.${architecture}"
      $build_number = "36"
      
      $freetype_file = "freetype-2.4.11-12.${platform}.${architecture}.rpm"
      $libxpm_file = "libXpm-3.5.11-3.${platform}.${architecture}.rpm"

      $apache_restart_cmd = "/usr/bin/systemctl restart httpd" #centos7
    } else {
      $major_version = '5'
      $minor_version = '3'
      $patch_version = '3'
    
      $platform = "el6"
      $os_specific = ".${platform}_6.${architecture}"
      $build_number = "46"
      
      $freetype_file = "freetype-2.3.11-15.${platform}_6.1.${architecture}.rpm"
      $libxpm_file = "libXpm-3.5.10-2.${platform}.${architecture}.rpm"

      $apache_restart_cmd = "/etc/init.d/httpd restart"
#      fail("${operatingsystem} version ${operatingsystemmajrelease} is not currently supported by the php module")
    }
  } else {
    fail("${operatingsystem} is not currently supported by the php module")
  }

  if (versioncmp("CentOS7", "${operatingsystem}${operatingsystemmajrelease}") == 0){
	  notify{"In libzip":}
	  $lib_zip = "libzip-0.10.1-8.${platform}.${architecture}"
	  $lib_zip_file = "${lib_zip}.rpm"
	  file{
	    "${local_install_dir}${lib_zip_file}":
	    ensure => present,
	    source => ["puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${$lib_zip_file}",]
	  }
	  package {"libzip":
	    ensure => present,
	    provider => 'rpm',
	    source => "${local_install_dir}${$lib_zip_file}",
      before => Package["php-common"],
	    require => [File["${local_install_dir}${lib_zip_file}"]],
	  }
    #Centos7
    $libx11_file = "libX11-1.6.3-2.${platform}.${architecture}.rpm"
    file{
      "${local_install_dir}${libx11_file}":
        ensure => present,
        source => ["puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libx11_file}",]
    }
    package {"libX11":
      ensure => present,
      provider => 'rpm',
      source => "${local_install_dir}${libx11_file}",
      before => Package["libXpm"],
      require => [File["${local_install_dir}${libx11_file}"],
        Package["libX11-common"], #centos7
        Package["libxcb"]],       #centos7
    }

    #Centos7
    $libx11_common_file = "libX11-common-1.6.3-2.${platform}.noarch.rpm"
    file{
      "${local_install_dir}${libx11_common_file}":
        ensure => present,
        source => ["puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libx11_common_file}",]
    }
    package {"libX11-common":
      ensure => present,
      provider => 'rpm',
      source => "${local_install_dir}${libx11_common_file}",
      require => File["${local_install_dir}${libx11_common_file}"],
    }
    #Centos7
    $libxcb_file = "libxcb-1.11-4.${platform}.${architecture}.rpm"
    file{
      "${local_install_dir}${libxcb_file}":
        ensure => present,
        source => ["puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libxcb_file}",]
    }
    package {"libxcb":
      ensure => present,
      provider => 'rpm',
      source => "${local_install_dir}${libxcb_file}",
      require => File["${local_install_dir}${libxcb_file}"],
    }
    #Centos7
    $libXau_file = "libXau-1.0.8-2.1.${platform}.${architecture}.rpm"
    file{
      "${local_install_dir}${libXau_file}":
        ensure => present,
        source => ["puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libXau_file}",]
    }
    package {"libXau":
      ensure => present,
      provider => 'rpm',
      source => "${local_install_dir}${libXau_file}",
      require => File["${local_install_dir}${libXau_file}"],
    }

    #Centos7
    #PHP-GD dependencies
    $libpng_file = "libpng-1.5.13-7.${platform}_2.${architecture}.rpm"
    file{
      "${local_install_dir}${libpng_file}":
        ensure => present,
        source => ["puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libpng_file}",]
    }
    package {"libpng":
      ensure => present,
      provider => 'rpm',
      source => "${local_install_dir}${libpng_file}",
      before => Package["php-gd"],
      require => File["${local_install_dir}${libpng_file}"],
    }

    #Centos7
    $libt1_file = "t1lib-5.1.2-14.${platform}.${architecture}.rpm"
    file{
      "${local_install_dir}${libt1_file}":
        ensure => present,
        source => ["puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libt1_file}",]
    }
    package {"t1lib":
      ensure => present,
      provider => 'rpm',
      source => "${local_install_dir}${libt1_file}",
      before => Package["php-gd"],
      require => [File["${local_install_dir}${libt1_file}"],
        Package["libX11"]],
    }

    #Centos7
    $libjpeg_file = "libjpeg-turbo-1.2.90-5.${platform}.${architecture}.rpm"
    file{
      "${local_install_dir}${libjpeg_file}":
        ensure => present,
        source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libjpeg_file}",
    }
    package {"libjpeg-turbo":
      ensure => present,
      provider => 'rpm',
      source => "${local_install_dir}${libjpeg_file}",
      before => Package["php-gd"],
      require => [File["${local_install_dir}${libjpeg_file}"]],
    }
  }
 
  $php_name = "php-${major_version}.${minor_version}.${patch_version}-${build_number}"
  $php_file = "${php_name}.rpm"  
  $php_file_os = "${php_name}${os_specific}.rpm"
  
  $php_cli = "php-cli-${major_version}.${minor_version}.${patch_version}-${build_number}"
  $php_cli_file = "${php_cli}.rpm"
  $php_cli_os = "${php_cli}${os_specific}.rpm"
  
  $php_common = "php-common-${major_version}.${minor_version}.${patch_version}-${build_number}"
  $php_common_file = "${php_common}"
  $php_common_os = "${php_common}${os_specific}.rpm"
  
  $php_mbstring = "php-mbstring-${major_version}.${minor_version}.${patch_version}-${build_number}"
  $php_mbstring_file = "${php_mbstring}.rpm"
  $php_mbstring_os = "${php_mbstring}${os_specific}.rpm"

  $php_pdo = "php-pdo-${major_version}.${minor_version}.${patch_version}-${build_number}"
  $php_pdo_file = "${php_pdo}.rpm"
  $php_pdo_os = "${php_pdo}${os_specific}.rpm"
   
  file{
    "${local_install_dir}${php_cli_file}":
    ensure => present,
    source => ["puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${php_cli_os}",]
  }  
  package {"php-cli":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${php_cli_file}",
    require => [File["${local_install_dir}${php_cli_file}"],Package["php-common"]],
  } 
  file{
    "${local_install_dir}${php_common_file}":
    ensure => present,
    source => ["puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${php_common_os}",]
  }
  package {"php-common":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${php_common_file}",
    require => [File["${local_install_dir}${php_common_file}"]],
  }
  file{
    "${local_install_dir}${php_file}":
    ensure => present,
    source => ["puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${php_file_os}",]
  }
  package {"php":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${php_file}",
    require => [File["${local_install_dir}${php_file}"], Package["php-common"], Package["php-cli"], Package["httpd"]],
#    notify => Service["httpd"],
  }
  exec {
    "restart_apache_for_php":
    require => Package["php"],
#    path => "/etc/",
    path => "/",
    command => "${apache_restart_cmd}",
    cwd => "/usr/bin/",
  } 
  
  file{
    "${local_install_dir}${php_mbstring_file}":
    ensure => present,
    source => ["puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${php_mbstring_os}",]
  }
  package {"php-mbstring":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${php_mbstring_file}",
    require => [File["${local_install_dir}${php_mbstring_file}"], Package["php-common"]],
  }  
  file{
    "${local_install_dir}${php_pdo_file}":
    ensure => present,
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${php_pdo_os}",
  }
  package {"php-pdo":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${php_pdo_file}",
    require => [File["${local_install_dir}${php_pdo_file}"],Package["php-common"]],
  }

  $php_gd = "php-gd-${major_version}.${minor_version}.${patch_version}-${build_number}"
  $php_gd_file = "${php_gd}.rpm"
  $php_gd_os = "${php_gd}${os_specific}.rpm"  
  file{
    "${local_install_dir}${php_gd_file}":
    ensure => present,
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${php_gd_os}",
  }
  package {"php-gd":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${php_gd_file}",
    require => [File["${local_install_dir}${php_gd_file}"], Package["php-common"], Package["freetype"], 
      Package["libXpm"]],
  }

  file{
    "${local_install_dir}${$freetype_file}":
    ensure => present,
    source => ["puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${freetype_file}",]
  }  
  package {"freetype":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${freetype_file}",
    require => File["${local_install_dir}${freetype_file}"],
  }

  file{
    "${local_install_dir}${libxpm_file}":
    ensure => present,
    source => ["puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libxpm_file}",]
  }
  package {"libXpm":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${libxpm_file}",
    require => [File["${local_install_dir}${libxpm_file}"]],
  }
     
  $php_mysql = "php-mysql-${major_version}.${minor_version}.${patch_version}-${build_number}"
  $php_mysql_file = "${php_mysql}.rpm"
  $php_mysql_os = "${php_mysql}${os_specific}.rpm"
  file{
    "${local_install_dir}${php_mysql_os}":
    ensure => present,
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${php_mysql_os}",
  }
  package {"php-mysql":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${php_mysql_os}",
    require => [File["${local_install_dir}${php_mysql_os}"], Class["mysql"], Package["php-pdo"]],
#      Package["mysql-community-libs-compat"]],
  }
}

  /*
   * Definition for modifying the php ini file using augeas.
   */
  define php::php_ini_file (
    $changes = undef,
  ) {
      include ::php
      if ($changes == undef){
        fail("You must supply the changes parameter to php::php_ini_file")
      } 
      augeas { 
        "php.ini":
        context => "/files/etc/php.ini/PHP/",
        changes => $changes,
#      [
#        "set short_open_tag On",      
#      ],
#        notify => Service["httpd"],
      #require => Package["php"], 
      #supplanted by the Class["php"] declaration but useful to know if this augeas call is externalised.
      }
    }
