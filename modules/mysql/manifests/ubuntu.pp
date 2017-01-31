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
  $os_platform = "-1-ubuntu14.04_amd64.deb"

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

  $mysql_community_server_file = "mysql-community-server_5.7.13${os_platform}"
  file {"${mysql_community_server_file}":
    ensure => present,
    path => "${local_install_dir}${mysql_community_server_file}",
    source => "puppet:///${$puppet_file_dir}${file_location}${mysql_community_server_file}",
  }

  package {"mysql-community-server":
    ensure      =>  installed,
    provider    =>  'dpkg',
    source      =>  "${local_install_dir}/${mysql_community_server_file}",
    require     =>  [File["${mysql_community_server_file}"],Package["libmecab2"], Package["mysql-client"]]
  }
}

/*
sudo dpkg -i /vagrant/files/Ubuntu/15.10/mysql-common_5.7.13-1-ubuntu14.04_amd64.deb
sudo dpkg -i /vagrant/files/Ubuntu/15.10/mysql-community-client_5.7.13-1-ubuntu14.04_amd64.deb
sudo dpkg -i /vagrant/files/Ubuntu/15.10/mysql-client_5.7.13-1-ubuntu14.04_amd64.deb
sudo dpkg -i /vagrant/files/Ubuntu/15.10/libmecab2_0.996-1.1_amd64.deb
sudo dpkg -i /vagrant/files/Ubuntu/15.10/mysql-community-server_5.7.13-1-ubuntu14.04_amd64.deb
*/