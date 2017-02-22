# Class: mysql
#
# This module manages mysql
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
#include fileserver
class mysql::centos (
  $major_version = undef,
  $minor_version = undef,
  $patch_version = undef,
  $password = undef,
  $root_home = undef,
){
  #Modify this into a class that we can pass args into, e.g. mysql version number, os speciic installer classes etc.
  #NOTE: This script will reset the root password if it cannot login to the mysql service
  $local_install_dir    = "${local_install_path}installers"
  $puppet_file_dir      = "modules/mysql/"

  $os = "$operatingsystem$operatingsystemmajrelease"

  $file_location = "${operatingsystem}/${operatingsystemmajrelease}/"
  if "${os}" == "CentOS7"{
    $os_platform          = "-1.el7.x86_64.rpm"
  } elsif "${os}" == "CentOS6" {
    $os_platform          = "-1.el6.x86_64.rpm"
  }

  $MySQL_common = "mysql-community-common-${major_version}.${minor_version}.${patch_version}${os_platform}"
  $MySQL_server = "mysql-community-server-${major_version}.${minor_version}.${patch_version}${os_platform}"
  $MySQL_client = "mysql-community-client-${major_version}.${minor_version}.${patch_version}${os_platform}"
  $MySQL_libs   = "mysql-community-libs-${major_version}.${minor_version}.${patch_version}${os_platform}"
  $MySQL_shared_compat = "mysql-community-libs-compat-${major_version}.${minor_version}.${patch_version}${os_platform}"

  #Load the installers from the puppet fileserver into the local filesystem
  #Try giving the file a name and separate target location so we don't need to fully qualify the path

  #Ensure that the local install directory exists
  #Ensure the destination directory for the installers is present

  if "${os}" == "CentOS7"{
    #  install libaio as it is needed by mysql-server package
    $libaio = "libaio-0.3.109-13.el7.x86_64.rpm"
    file {
      "${libaio}":
        path    =>  "${local_install_dir}/${libaio}",
        ensure  =>  present,
        source  =>  ["puppet:///${puppet_file_dir}${file_location}${libaio}"],
    }
    package {
      'libaio':
        ensure      =>  installed,
        provider    =>  'rpm',
        source      =>  "${local_install_dir}/${libaio}",
        require     =>  File["${libaio}"],
        before      =>  [Package['mysql-community-common'], Package['mysql-community-server'], Package['mysql-community-client']],
    }
    package {
      "postfix":
        ensure    => absent,
        provider  => 'rpm',
    }
    package {
      'mariadb-libs':
        ensure      =>  absent,
        provider    =>  'rpm',
        before      =>  [Package['mysql-community-common'], Package['mysql-community-server'], Package['mysql-community-client']],
        require     =>  Package["postfix"]
    }
  } elsif "${os}" == "CentOS6" {
    package {"mysql-libs":
      provider => "rpm",
      ensure => absent,
      before => Package["mysql-community-common"],
      uninstall_options => ["--nodeps"]
    }
  }

  file {
    "${MySQL_common}":
      path    =>  "${local_install_dir}/${MySQL_common}",
      ensure  =>  present,
      source  =>  ["puppet:///${puppet_file_dir}${file_location}${MySQL_common}"],
  }

  package {
    'mysql-community-common':
      ensure      =>  installed,
      provider    =>  'rpm',
      source      =>  "${local_install_dir}/${MySQL_common}",
      require     =>  [File["${MySQL_common}"]],
  }

  file {
    "${MySQL_libs}":
      path        => "${$local_install_dir}/${MySQL_libs}",
      ensure      =>  present,
      source      =>  ["puppet:///${puppet_file_dir}${file_location}${MySQL_libs}"],
  }

  package {
    'mysql-community-libs':
      ensure      =>  installed,
      provider    =>  'rpm',
      source      =>  "${local_install_dir}/${MySQL_libs}",
      require     =>  [File["${MySQL_libs}"],
        Package["mysql-community-common"]],
  }

  file {
    "${MySQL_shared_compat}":
      path    =>  "${local_install_dir}/${MySQL_shared_compat}",
      ensure  =>  present,
      source  =>  ["puppet:///${puppet_file_dir}${file_location}${MySQL_shared_compat}"],
  }

  package {
    'mysql-community-libs-compat':
      ensure      =>  installed,
      provider    =>  'rpm',
      source      =>  "${local_install_dir}/${MySQL_shared_compat}",
      require     =>  [File["${MySQL_shared_compat}"],
        Package["mysql-community-libs"]
      ],
  }

  file{
    "${MySQL_client}":
      path      => "${local_install_dir}/${MySQL_client}",
      ensure    => present,
      source    => ["puppet:///${puppet_file_dir}${file_location}${MySQL_client}"],
  }

  package {
    'mysql-community-client':
      ensure      =>  installed,
      provider    =>  'rpm',
      source      =>  "${local_install_dir}/${MySQL_client}",
      require     =>  [File["${MySQL_client}"]],
  }

  file {
    "${MySQL_server}":
      path    =>  "${local_install_dir}/${MySQL_server}",
      ensure  =>  present,
      source  =>  ["puppet:///${puppet_file_dir}${file_location}${MySQL_server}"],
  }

  package {
    'mysql-community-server':
      ensure      =>  installed,
      provider    =>  'rpm',
      source      =>  "${local_install_dir}/${MySQL_server}",
      require     =>  [File["${MySQL_server}"],
        Package["mysql-community-libs-compat"],
        Package["mysql-community-client"],
        Package["mysql-community-common"]
      ],
      notify      => Service["mysqld"],
  }

  notify{"Starting mysqld":
    require => Package["mysql-community-server"]
  }

  if ("${os}" == "CentOS7"){
    service {"mysql":
      name => "mysqld",
      ensure => running,
      enable => true,
      require => Package["mysql-community-server"],
    }
  } elsif "${os}" == "CentOS6" {
    service {"mysql":
      name => "mysqld",
      ensure => running,
      enable => true,
      require => Package["mysql-community-server"],
    }
  }

  #1. Find the previous password in the my.cnf
  #2. If .my.cnf doesn't exist then find the temporary password
  #3. Set the new root password
  #4. Set root password in the my.cnf template file and place it in the /home/root directory
  #5. Create regular mysql users using the root user, not sure if vagrant can do this?

  if (("${major_version}.${minor_version}.${patch_version}" == "5.7.13") and ("${os}" == "CentOS6")){
    exec {"reset temp password":
      path => "/usr/bin/",
      onlyif => "test ! -f ${root_home}/.my.cnf",
      command => "mysql -uroot --password=\"$(sudo grep 'temporary password' /var/log/mysqld.log | awk '{ print \$11 }')\"  --connect-expired-password -e\"SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${password}');\"",
      require => [Service["mysqld"]],
      before => File["my.cnf"],
    }

    exec {"confirm root password":
      path => "/usr/bin/",
      onlyif => "test -f ${root_home}/.my.cnf",
      command => "mysql -uroot --password=\"$(sudo grep 'password=' ${root_home}/.my.cnf | awk '{print \$2}')\"  --connect-expired-password -e\"SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${password}');\"",
      require => [Service["mysqld"]],
      before => File["my.cnf"],
    }
  } elsif (("${major_version}.${minor_version}.${patch_version}" == "5.7.13") and ("${os}" == "CentOS7")) {
    exec {"reset temp password":
      path => "/usr/bin/",
      onlyif => "test ! -f ${root_home}/.my.cnf",
      command => "mysqladmin -uroot --password=\$(sudo grep 'temporary password' /var/log/mysqld.log | awk '{print \$11}') password '${password}'",
      require => [Service["mysqld"]],
      before => File["my.cnf"],
    }

    exec {"confirm root password":
      path => "/usr/bin/",
      onlyif => "test -f ${root_home}/.my.cnf",
      command => "mysqladmin -uroot --password=\$(sudo grep 'password=' ${root_home}/.my.cnf | awk '{print \$2}') password '${password}'",
      require => [Service["mysqld"]],
      before => File["my.cnf"],
    }
  } else {
    fail("MySQL ${major_version}.${minor_version}.${patch_version} not supported yet for ${os}")
  }

  #if we can login with the expected password then do nothing, if not then we need to add it to the .my.cnf file.
  file {
    "my.cnf":
      path    => "${root_home}/.my.cnf",
      ensure  =>  present,
      mode => 0655,
      content => template("${module_name}/my.cnf.erb"),
      require => [Service["mysqld"]],
  }
}

