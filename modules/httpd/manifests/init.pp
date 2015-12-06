# Class: httpd
#
# This module manages httpd
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class httpd {

  $puppet_file_dir = "modules/httpd/"
  #$puppet_file_dir = "modules/${module_name}"
  
#  Package["httpd"] -> Package["httpd-tools"] -> Package["mailcap"] ->
#  Package["apr-util-ldap"] -> Package["apr-util"] -> Package["apr"] 

  $apr_file = "apr-1.3.9-5.el6_2.x86_64.rpm"
  file{
    "${local_install_dir}${apr_file}":
    ensure => present,
    path => "${local_install_dir}${apr_file}",
    source => ["puppet:///${puppet_file_dir}${apr_file}"]
  }
  package {"apr":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${apr_file}",
    require => File["${local_install_dir}${apr_file}"]
  }
  $apr_utils_file = "apr-util-1.3.9-3.el6_0.1.x86_64.rpm"
  file{
    "${local_install_dir}${apr_utils_file}":
    ensure => present,
    path => "${local_install_dir}${apr_utils_file}",
    source => ["puppet:///${puppet_file_dir}${apr_utils_file}"]
  }
  package {"apr-util":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${apr_utils_file}",
    require => [File["${local_install_dir}${apr_utils_file}"], Package["apr"]]
  }
  $apr_utils_ldap_file = "apr-util-ldap-1.3.9-3.el6_0.1.x86_64.rpm"
  file{
    "${local_install_dir}${apr_utils_ldap_file}":
    ensure => present,
    path => "${local_install_dir}${apr_utils_ldap_file}",
    source => ["puppet:///${puppet_file_dir}${apr_utils_ldap_file}"]
  }
  package {"apr-util-ldap":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${apr_utils_ldap_file}",
    require => [File["${local_install_dir}${apr_utils_ldap_file}"], Package["apr"], Package["apr-util"]]
  }
  $mail_cap_file = "mailcap-2.1.31-2.el6.noarch.rpm"
  file{
    "${local_install_dir}${mail_cap_file}":
    ensure => present,
    path => "${local_install_dir}${mail_cap_file}",
    source => ["puppet:///${puppet_file_dir}${mail_cap_file}"]
  }
  package {"mailcap":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${mail_cap_file}",
    require => File["${local_install_dir}${mail_cap_file}"]
  }
  $httpd_tools_file = "httpd-tools-2.2.15-47.el6.centos.x86_64.rpm"
  file{
    "${local_install_dir}${httpd_tools_file}":
    ensure => present,
    path => "${local_install_dir}${httpd_tools_file}",
    source => ["puppet:///${puppet_file_dir}${httpd_tools_file}"]
  }
  package {"httpd-tools":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${httpd_tools_file}",
    require => [File["${local_install_dir}${httpd_tools_file}"],Package["apr-util"]]
  }
  $httpd_file = "httpd-2.2.15-47.el6.centos.x86_64.rpm"
  file{
    "${local_install_dir}${httpd_file}":
    ensure => present,
    path => "${local_install_dir}${httpd_file}",
    source => ["puppet:///${puppet_file_dir}${httpd_file}",]
  }
  package {"httpd":
    ensure => present, #will require the yum / puppet resource package name
    provider => 'rpm',
    source => "${local_install_dir}${httpd_file}",
    require => [File["${local_install_dir}${httpd_file}"], Package["apr-util-ldap"], 
    Package["mailcap"], Package["httpd-tools"], Package["apr-util"]],
    #version 2.2.15
  }
  service {
    "httpd":
    require => Package["httpd"],
    ensure => running,
    enable => true
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
}