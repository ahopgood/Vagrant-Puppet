# Class: httpd
#
# This module manages httpd.
# Note that there are folder hierarchy dependencies on /etc/puppt/installers.
# Also requires port 80 to be open or else navigating to the ip address will fail, if open you will see the apache welcome page.
# Use of the iptables class is recommended.
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
  $local_install_dir = "${local_install_path}installers/"

  $httpd_user = "httpd"
  $httpd_group = "httpd"

  Class["httpd"] -> Class["iptables"]

  $os = "$operatingsystem$operatingsystemmajrelease"
  
  $apr_file = $os ? {
    'CentOS7' => "apr-1.4.8-3.el7.x86_64.rpm",
    'CentOS6' => "apr-1.3.9-5.el6_2.x86_64.rpm",
  }
  $apr_utils_file = $os ? {
    'CentOS7' => "apr-util-1.5.2-6.el7.x86_64.rpm",
    'CentOS6' => "apr-util-1.3.9-3.el6_0.1.x86_64.rpm",
  }
  $apr_utils_ldap_file = $os ? {
    'CentOS7' => "apr-util-ldap-1.5.2-6.el7.x86_64.rpm",
    'CentOS6' => "apr-util-ldap-1.3.9-3.el6_0.1.x86_64.rpm",
  }
  $httpd_tools_file = $os ? {
    'CentOS7' => "httpd-tools-2.4.6-40.el7.centos.1.x86_64.rpm",
    'CentOS6' => "httpd-tools-2.2.15-47.el6.centos.x86_64.rpm",
  }
  $mail_cap_file = $os ? {
    'CentOS7' => "mailcap-2.1.41-2.el7.noarch.rpm",
    'CentOS6' => "mailcap-2.1.31-2.el6.noarch.rpm",
  }
  $httpd_file = $os ? {
    'CentOS7' => "httpd-2.4.6-40.el7.centos.1.x86_64.rpm",
    'CentOS6' => "httpd-2.2.15-47.el6.centos.x86_64.rpm",
  }

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
  
  group { "${httpd_group}":
    ensure    =>  present,
  }
  
  user { "${httpd_user}":
    ensure      =>  present,
    home        =>  "/home/${httpd_user}",
    managehome  =>  true,
    shell       =>  '/bin/bash',
    groups      =>  ["${httpd_group}"],
    require     =>  Group["${httpd_group}"]
  }
  
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

  file{
    "${local_install_dir}${httpd_file}":
    ensure => present,
    mode      =>  0660,
    owner     =>  "${httpd_user}",
    group     =>  "${httpd_group}",
    path => "${local_install_dir}${httpd_file}",
    source => ["puppet:///${puppet_file_dir}${httpd_file}",]
  }
  
  package {"httpd":
    ensure => present, #will require the yum / puppet resource package name
    provider => 'rpm',
    source => "${local_install_dir}${httpd_file}",
    require => [File["${local_install_dir}${httpd_file}"],
    User["${httpd_user}"],
    Package["apr-util-ldap"], 
    Package["mailcap"], Package["httpd-tools"], Package["apr-util"]],
  }
  
  service {
    "httpd":
    require => Package["httpd"],
    ensure => running,
    enable => true
  }
}