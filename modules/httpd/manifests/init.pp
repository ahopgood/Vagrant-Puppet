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
  
#  Package["httpd"] -> Package["httpd-tools"] -> Package["mailcap"] ->
#  Package["apr-util-ldap"] -> Package["apr-util"] -> Package["apr"] 

  $apr_file = "apr-1.3.9-5.el6_2.x86_64.rpm"
  file{
    "${apr_file}":
    ensure => present,
    path => "${local_install_dir}${apr_file}",
    source => ["puppet:///${puppet_file_dir}${apr_file}"]
  }
  package {"apr":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${apr_file}",
    require => File["${apr_file}"]
  }
  $apr_utils_file = "apr-util-1.3.9-3.el6_0.1.x86_64.rpm"
  file{
    "${apr_utils_file}":
    ensure => present,
    path => "${local_install_dir}${apr_utils_file}",
    source => ["puppet:///${puppet_file_dir}${apr_utils_file}"]
  }
  package {"apr-util":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${apr_utils_file}",
    require => [File["${apr_utils_file}"], Package["apr"]]
  }
  $apr_utils_ldap_file = "apr-util-ldap-1.3.9-3.el6_0.1.x86_64.rpm"
  file{
    "${apr_utils_ldap_file}":
    ensure => present,
    path => "${local_install_dir}${apr_utils_ldap_file}",
    source => ["puppet:///${puppet_file_dir}${apr_utils_ldap_file}"]
  }
  package {"apr-util-ldap":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${apr_utils_ldap_file}",
    require => [File["${apr_utils_ldap_file}"], Package["apr"], Package["apr-util"]]
  }
  $mail_cap_file = "mailcap-2.1.31-2.el6.noarch.rpm"
  file{
    "${mail_cap_file}":
    ensure => present,
    path => "${local_install_dir}${mail_cap_file}",
    source => ["puppet:///${puppet_file_dir}${mail_cap_file}"]
  }
  package {"mailcap":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${mail_cap_file}",
    require => File["${mail_cap_file}"]
  }
  $httpd_tools_file = "httpd-tools-2.2.15-47.el6.centos.x86_64.rpm"
  file{
    "${httpd_tools_file}":
    ensure => present,
    path => "${local_install_dir}${httpd_tools_file}",
    source => ["puppet:///${puppet_file_dir}${httpd_tools_file}"]
  }
  package {"httpd-tools":
    ensure => present,
    provider => 'rpm',
    source => "${local_install_dir}${httpd_tools_file}",
    require => File["${httpd_tools_file}"]
  }
  $httpd_file = "httpd-2.2.15-47.el6.centos.x86_64.rpm"
  file{
    "${httpd_file}":
    ensure => present,
    path => "${local_install_dir}${httpd_file}",
    source => ["puppet:///${puppet_file_dir}${httpd_file}",]
  }
  package {"httpd":
    ensure => present, #will require the yum / puppet resource package name
    provider => 'rpm',
    source => "${local_install_dir}${httpd_file}",
    require => [File["${httpd_file}"], Package["apr-util-ldap"], 
    Package["mailcap"], Package["httpd-tools"], Package["apr-util"]],
    #version 2.2.15
  }
  service {
    "httpd":
    require => Package["httpd"],
    ensure => running,
    enable => true
  }
}
