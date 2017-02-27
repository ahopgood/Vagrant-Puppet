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

  if (versioncmp("${major_version}", 5) == 0) {
    if (versioncmp("${minor_version}", 7) == 0) {
      $MySQL_common = "mysql-community-common-${major_version}.${minor_version}.${patch_version}${os_platform}"
      $MySQL_server = "mysql-community-server-${major_version}.${minor_version}.${patch_version}${os_platform}"
      $MySQL_client = "mysql-community-client-${major_version}.${minor_version}.${patch_version}${os_platform}"
      $MySQL_libs   = "mysql-community-libs-${major_version}.${minor_version}.${patch_version}${os_platform}"
      $MySQL_shared_compat = "mysql-community-libs-compat-${major_version}.${minor_version}.${patch_version}${os_platform}"

      $MySQL_common_package_name = "mysql-community-common"
      $MySQL_server_package_name = "mysql-community-server"
      $MySQL_client_package_name = "mysql-community-client"
      $MySQL_libs_package_name = "mysql-community-libs"
      $MySQL_shared_compat_package_name = "mysql-community-libs-compat"

    } elsif (versioncmp("${minor_version}", 6) == 0){
      $MySQL_server = "MySQL-server-${major_version}.${minor_version}.${patch_version}${os_platform}"
      $MySQL_client = "MySQL-client-${major_version}.${minor_version}.${patch_version}${os_platform}"
      $MySQL_libs   = "MySQL-shared-${major_version}.${minor_version}.${patch_version}${os_platform}"
      $MySQL_shared_compat = "MySQL-shared-compat-${major_version}.${minor_version}.${patch_version}${os_platform}"

      $MySQL_server_package_name = "MySQL-server"
      $MySQL_client_package_name = "MySQL-client"
      $MySQL_libs_package_name = "MySQL-shared"
      $MySQL_shared_compat_package_name = "MySQL-shared-compat"
    } else {
      fail("Minor Version ${minor_version} isn't currently supported for MySQL ${major_version} on ${os}")
    }
  } else {
    fail("Major Version ${major_version} isn't currently supported for ${os}")
  }

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
#        before      =>  [Package['mysql-community-libs'], Package['mysql-community-server'], Package['mysql-community-client']],
        before      =>  [Package['mysql-community-libs'], Package['mysql-community-client']],
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
#        before      =>  [Package['mysql-community-libs'], Package['mysql-community-server'], Package['mysql-community-client']],
        before      =>  [Package['mysql-community-libs'], Package['mysql-community-client']],
        require     =>  Package["postfix"]
    }
    if (versioncmp("${minor_version}", 6) == 0) and (versioncmp("${os}", "CentOS7") == 0) {
      $perl_data_dumper_file = "perl-Data-Dumper-2.145-3.el7.x86_64.rpm"
      file {
        "${perl_data_dumper_file}":
          path    =>  "${local_install_dir}/${perl_data_dumper_file}",
          ensure  =>  present,
          source  =>  ["puppet:///${puppet_file_dir}${file_location}${perl_data_dumper_file}"],
      }
      package {
        'perl-Data-Dumper':
          ensure      =>  installed,
          provider    =>  'rpm',
          source      =>  "${local_install_dir}/${perl_data_dumper_file}",
          require     =>  [File["${perl_data_dumper_file}"]],
          before      =>  [Package["mysql-community-server"]]
      }
    }
  } elsif "${os}" == "CentOS6" {
    package {"mysql-libs":
      provider => "rpm",
      ensure => absent,
#      before => Package["mysql-community-common"],
      before => [Package['mysql-community-libs']],
      uninstall_options => ["--nodeps"]
    }
  }

  #Only install the mysql-community-common packag for version 5.7 of mysql
  if (versioncmp("${minor_version}", 7) == 0) {
    file {
      "${MySQL_common}":
        path    =>  "${local_install_dir}/${MySQL_common}",
        ensure  =>  present,
        source  =>  ["puppet:///${puppet_file_dir}${file_location}${MySQL_common}"],
    }
    package {
      'mysql-community-common':
        name        =>  "${MySQL_common_package_name}",
        ensure      =>  installed,
        provider    =>  'rpm',
        source      =>  "${local_install_dir}/${MySQL_common}",
        require     =>  [File["${MySQL_common}"]],
        before      =>  [Package["mysql-community-server"],Package["mysql-community-libs"]]
    }
  }

  file {
    "${MySQL_libs}":
      path        => "${$local_install_dir}/${MySQL_libs}",
      ensure      =>  present,
      source      =>  ["puppet:///${puppet_file_dir}${file_location}${MySQL_libs}"],
  }

  package {
    'mysql-community-libs':
      name        =>  "${MySQL_libs_package_name}",
      ensure      =>  installed,
      provider    =>  'rpm',
      source      =>  "${local_install_dir}/${MySQL_libs}",
      require     =>  [File["${MySQL_libs}"]],
  }

  file {
    "${MySQL_shared_compat}":
      path    =>  "${local_install_dir}/${MySQL_shared_compat}",
      ensure  =>  present,
      source  =>  ["puppet:///${puppet_file_dir}${file_location}${MySQL_shared_compat}"],
  }

  package {
    'mysql-community-libs-compat':
      name        =>  "${MySQL_shared_compat_package_name}",
      ensure      =>  installed,
      provider    =>  'rpm',
      source      =>  "${local_install_dir}/${MySQL_shared_compat}",
      require     =>  [ File["${MySQL_shared_compat}"],
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
      name        =>  "${MySQL_client_package_name}",
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
      name        =>  "${MySQL_server_package_name}",
      ensure      =>  installed,
      provider    =>  'rpm',
      source      =>  "${local_install_dir}/${MySQL_server}",
      require     =>  [File["${MySQL_server}"],
        Package["mysql-community-libs-compat"],
        Package["mysql-community-client"],
      ],
      notify      => Service["mysql"],
  }

  notify{"Starting mysqld":
    require => Package["mysql-community-server"]
  }

  if (versioncmp("${major_version}.${minor_version}","5.7") == 0 ){
    $service_name = "mysqld"
  } elsif (versioncmp("${major_version}.${minor_version}","5.6") == 0 ) {
      $service_name = "mysql"
  }
  service {"mysql":
    name => "${service_name}",
    ensure => running,
    enable => true,
    require => Package["mysql-community-server"],
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
      require => [Service["mysql"]],
      before => File["my.cnf"],
    }

    exec {"confirm root password":
      path => "/usr/bin/",
      onlyif => "test -f ${root_home}/.my.cnf",
      command => "mysql -uroot --password=\"$(sudo grep 'password=' ${root_home}/.my.cnf | awk '{print \$2}')\"  --connect-expired-password -e\"SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${password}');\"",
      require => [Service["mysql"]],
      before => File["my.cnf"],
    }
  } elsif (("${major_version}.${minor_version}.${patch_version}" == "5.6.35") and (("${os}" == "CentOS7") or ("${os}" == "CentOS6"))) {
    exec {"reset temp password":
      path => "/usr/bin/",
      onlyif => "test ! -f ${root_home}/.my.cnf",
      command => "mysqladmin -uroot --password=\$(sudo cat /.mysql_secret | awk '{print \$18}') password '${password}'",
      require => [Service["mysql"]],
      before => File["my.cnf"],
    }

    exec {"confirm root password":
      path => "/usr/bin/",
      onlyif => "test -f ${root_home}/.my.cnf",
      command => "mysqladmin -uroot --password=\$(sudo grep 'password=' ${root_home}/.my.cnf | awk '{print \$2}') password '${password}'",
      require => [Service["mysql"]],
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
      require => [Service["mysql"]],
  }
}

