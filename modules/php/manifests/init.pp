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
class php {
  notify{"PHP Module running":}

  Class["mysql"]
  ->
  Class["php"]
  
#  Class["httpd"]
#  ->
#  Class["php"]
  
#  include ::httpd
  
  $puppet_file_dir = "modules/${module_name}/"
  $local_install_dir = "${local_install_path}installers/"

  $php_file = "php-5.3.3-46.el6_6.x86_64.rpm"
  $php_cli_file = "php-cli-5.3.3-46.el6_6.x86_64.rpm"
  $php_common_file = "php-common-5.3.3-46.el6_6.x86_64.rpm"
  $php_mbstring_file = "php-mbstring-5.3.3-46.el6_6.x86_64.rpm"
  $php_pdo_file = "php-pdo-5.3.3-46.el6_6.x86_64.rpm"
  $php_gd_file = "php-gd-5.3.3-46.el6_6.x86_64.rpm"
  $php_mysql_file = "php-mysql-5.3.3-46.el6_6.x86_64.rpm"

  file{
    "${local_install_dir}${php_cli_file}":
    ensure => present,
    source => ["puppet:///${puppet_file_dir}${php_cli_file}",]
  }  
  package {"php-cli":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${php_cli_file}",
    require => File["${local_install_dir}${php_cli_file}"],
    #version 5.3.3
  } 
  file{
    "${local_install_dir}${php_common_file}":
    ensure => present,
    source => ["puppet:///${puppet_file_dir}${php_common_file}",]
  }
  package {"php-common":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${php_common_file}",
    require => File["${local_install_dir}${php_common_file}"],
    #version 5.3.3
  }
  file{
    "${local_install_dir}${php_file}":
    ensure => present,
    source => ["puppet:///${puppet_file_dir}${php_file}",]
  }
  package {"php":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${php_file}",
    require => [File["${local_install_dir}${php_file}"], Package["php-common"], Package["php-cli"], Class["httpd"]],
#    notify => Service["httpd"],
    #version 5.3.3
  }
  exec {
    "restart_apache_for_php":
    require => Package["php"],
    command => "/etc/init.d/httpd restart",
    cwd => "/usr/bin/",
  } 
  
  file{
    "${local_install_dir}${php_mbstring_file}":
    ensure => present,
    source => ["puppet:///${puppet_file_dir}${php_mbstring_file}",]
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
    source => "puppet:///${puppet_file_dir}${php_pdo_file}",
  }
  package {"php-pdo":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${php_pdo_file}",
    require => [File["${local_install_dir}${php_pdo_file}"],Package["php-common"]],
  }
  file{
    "${local_install_dir}${php_gd_file}":
    ensure => present,
    source => "puppet:///${puppet_file_dir}${php_gd_file}",
  }
  package {"php-gd":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${php_gd_file}",
    require => [File["${local_install_dir}${php_gd_file}"], Package["php-common"], Package["freetype"], Package["libXpm"]],
    #2.0.34
  }
  $freetype_file = "freetype-2.3.11-15.el6_6.1.x86_64.rpm"
  file{
    "${local_install_dir}${$freetype_file}":
    ensure => present,
    source => ["puppet:///${puppet_file_dir}${freetype_file}",]
  }  
  package {"freetype":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${freetype_file}",
    require => File["${local_install_dir}${freetype_file}"],
    #version 5.3.3
  }

  $libxpm_file = "libXpm-3.5.10-2.el6.x86_64.rpm"
  file{
    "${local_install_dir}${libxpm_file}":
    ensure => present,
    source => ["puppet:///${puppet_file_dir}${libxpm_file}",]
  }
  package {"libXpm":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${libxpm_file}",
#    source => ["puppet:///${puppet_file_dir}${libxpm_file}",]
    require => File["${local_install_dir}${libxpm_file}"],
    #version 5.3.3
  }
  
  file{
    "${local_install_dir}${php_mysql_file}":
    ensure => present,
    source => "puppet:///${puppet_file_dir}${php_mysql_file}",
  }
  package {"php-mysql":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${php_mysql_file}",
    require => [File["${local_install_dir}${php_mysql_file}"], Class["mysql"], Package["php-pdo"]],
    #5.1.73
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
        notify => Service["httpd"],
      #require => Package["php"], 
      #supplanted by the Class["php"] declaration but useful to know if this augeas call is externalised.
      }
    }
