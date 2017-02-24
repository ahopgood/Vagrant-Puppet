class mysql::ubuntu(
  $major_version = undef,
  $minor_version = undef,
  $patch_version = undef,
  $password = undef,
  $root_home = undef,
){

  notify {"In Ubuntu15.10":}

  $local_install_dir    = "${local_install_path}installers/"
  $puppet_file_dir      = "modules/mysql/"

  $file_location = "${operatingsystem}/${operatingsystemmajrelease}/"
  $os = "$operatingsystem$operatingsystemmajrelease"
  $extension = ".deb"
  $os_platform = "-1ubuntu14.04_amd64${extension}"

  if (versioncmp("${major_version}", 5) == 0) {
    if (versioncmp("${minor_version}", 7) == 0) {

    } else {
      fail("Minor Version ${minor_version} isn't currently supported for MySQL ${major_version} on ${os}")
    }
  } else {
    fail("Major Version ${major_version} isn't currently supported for ${os}")
  }


  $mysql_common_file = "mysql-common_5.7.13${os_platform}"
  file {"${mysql_common_file}":
    ensure => present,
    path => "${local_install_dir}${mysql_common_file}",
    source => "puppet:///${$puppet_file_dir}${file_location}${mysql_common_file}",
  }

  package {"mysql-common":
      ensure      =>  installed,
      provider    =>  'dpkg',
      source      =>  "${local_install_dir}/${mysql_common_file}",
      require     =>  [File["${mysql_common_file}"]]
  }

  $mysql_community_client_file = "mysql-community-client_5.7.13${os_platform}"
  file {"${mysql_community_client_file}":
    ensure => present,
    path => "${local_install_dir}${mysql_community_client_file}",
    source => "puppet:///${$puppet_file_dir}${file_location}${mysql_community_client_file}",
  }

  package {"mysql-community-client":
    ensure      =>  installed,
    provider    =>  'dpkg',
    source      =>  "${local_install_dir}/${mysql_community_client_file}",
    require     =>  [File["${mysql_community_client_file}"],Package["mysql-common"]]
  }

  #Seems to hang, perhaps this is a splash screen?
  $mysql_client_file = "mysql-client_5.7.13${os_platform}"
  file {"${mysql_client_file}":
    ensure => present,
    path => "${local_install_dir}${mysql_client_file}",
    source => "puppet:///${$puppet_file_dir}${file_location}${mysql_client_file}",
  }

  package {"mysql-client":
    ensure      =>  installed,
    provider    =>  'dpkg',
    source      =>  "${local_install_dir}/${mysql_client_file}",
    require     =>  [File["${mysql_client_file}"], Package["mysql-community-client"]]
  }

  $libmecab2_file = "libmecab2_0.996-1.1_amd64.deb"
  file {"${libmecab2_file}":
    ensure => present,
    path => "${local_install_dir}${libmecab2_file}",
    source => "puppet:///${$puppet_file_dir}${file_location}${libmecab2_file}",
  }

  package {"libmecab2":
    ensure      =>  installed,
    provider    =>  'dpkg',
    source      =>  "${local_install_dir}/${libmecab2_file}",
    require     =>  File["${libmecab2_file}"],
  }

  # Turn off prompts (the frontend)
  #export DEBIAN_FRONTEND="noninteractive"

  # Set the values we wish to enter via debconf which will allow the selections / values to be used by the installer
  #sudo debconf-set-selections <<< "mysql-community-server mysql-community-server/root_pass password "
  #sudo debconf-set-selections <<< "mysql-community-server mysql-community-server/re-root_pass  password "
  # To Check selections
  #sudo debconf-get-selections | grep mysql

  exec {"set root password":
    path => "/bin/",
    command => "/bin/echo mysql-community-server mysql-community-server/root-pass password ${password} | /usr/bin/debconf-set-selections",
  }

  exec {"confirm root password":
    path => "/bin/",
    command => "/bin/echo mysql-community-server mysql-community-server/re-root-pass  password ${password} | /usr/bin/debconf-set-selections",
  }

  #How to reset when running again?
  $mysql_community_server_file = "mysql-community-server_5.7.13${os_platform}"

  file {"${mysql_community_server_file}":
    ensure => present,
    path => "${local_install_dir}${mysql_community_server_file}",
    source => "puppet:///${$puppet_file_dir}${file_location}${mysql_community_server_file}",
    mode => 777,
  }

  exec {"mysql-community-server":
    path => ["/usr/bin/","/bin/","/usr/sbin", "/sbin", "/usr/local/sbin"],
    environment => ["DEBIAN_FRONTEND=noninteractive"],
    command =>  "dpkg -i ${local_install_dir}${mysql_community_server_file}",
    logoutput => on_failure,
    notify => Service["mysql"],
    require =>  [File["${mysql_community_server_file}"],
      Package["libmecab2"],
      Package["mysql-client"],
      Exec["set root password"],
      Exec["confirm root password"],
    ]
  }
  service{"mysql":
    name => "mysql",
    ensure => running,
    enable => true,
    require => Exec["mysql-community-server"],
  }

  #Use systemd to run mysql
}

/*
sudo dpkg -i /vagrant/files/Ubuntu/15.10/mysql-common_5.7.13-1ubuntu14.04_amd64.deb
sudo dpkg -i /vagrant/files/Ubuntu/15.10/mysql-community-client_5.7.13-1ubuntu14.04_amd64.deb
sudo dpkg -i /vagrant/files/Ubuntu/15.10/mysql-client_5.7.13-1ubuntu14.04_amd64.deb
sudo dpkg -i /vagrant/files/Ubuntu/15.10/libmecab2_0.996-1.1_amd64.deb
sudo dpkg -i /vagrant/files/Ubuntu/15.10/mysql-community-server_5.7.13-1ubuntu14.04_amd64.deb
*/