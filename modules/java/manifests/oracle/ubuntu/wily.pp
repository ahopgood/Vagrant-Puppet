define java::oracle::ubuntu::wily(
  $package_name = undef,
  $update_version = undef
) {
  include java::oracle::ubuntu::wily::deps

  realize(File["${java::oracle::ubuntu::wily::deps::libasound}"])
  realize(Package["${java::oracle::ubuntu::wily::deps::libasound_package}"])

  realize(File["${java::oracle::ubuntu::wily::deps::libasound_data}"])
  realize(Package["${java::oracle::ubuntu::wily::deps::libasound_data_package}"])

  realize(File["${java::oracle::ubuntu::wily::deps::libgtk_common}"])
  realize(Package["${java::oracle::ubuntu::wily::deps::libgtk_common_package}"])

  realize(File["${java::oracle::ubuntu::wily::deps::libgtk}"])
  realize(Package["${java::oracle::ubuntu::wily::deps::libgtk_package}"])
}
class java::oracle::ubuntu::wily::deps {
  $local_install_path = "/etc/puppet/"
  $local_install_dir  = "${local_install_path}installers/"
  $puppet_file_dir    = "modules/java/"

  $libasound_data = "libasound2-data_1.0.29-0ubuntu1_all.deb"
  $libasound_data_package = "libasound2-data"

  @file {"${libasound_data}":
    require    =>  File["${local_install_dir}"],
    path       =>  "${local_install_dir}${libasound_data}",
    ensure     =>  present,
    source     =>  ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${libasound_data}"]
  }
  @package {
    "${libasound_data_package}":
      ensure      => installed,
      provider    =>  'dpkg',
      source      =>  "${local_install_dir}${libasound_data}",
      require     =>  File["${libasound_data}"],
  }

  $libasound = "libasound2_1.0.29-0ubuntu1_amd64.deb"
  $libasound_package = "libasound2"
  @file {"${libasound}":
    require    =>  File["${local_install_dir}"],
    path       =>  "${local_install_dir}${libasound}",
    ensure     =>  present,
    source     =>  ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${libasound}"]
  }
  @package {
    "${libasound_package}":
      ensure      => installed,
      provider    =>  'dpkg',
      source      =>  "${local_install_dir}${libasound}",
      require     =>  [File["${libasound}"],
        Package["${libasound_data_package}"],
      ],
      # before      =>  Package["${java::oracle::ubuntu::wily::package_name}u${java::oracle::ubuntu::wily::update_version}"]
  }

  $libgtk_common = "libgtk2.0-common_2.24.28-1ubuntu1.1_all.deb"
  $libgtk_common_package = "libgtk2.0-common"
  @file {"${libgtk_common}":
    require    =>  File["${local_install_dir}"],
    path       =>  "${local_install_dir}${libgtk_common}",
    ensure     =>  present,
    source     =>  ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${libgtk_common}"]
  }
  @package {
    "${libgtk_common_package}":
      ensure      => installed,
      provider    =>  'dpkg',
      source      =>  "${local_install_dir}${libgtk_common}",
      require     =>  File["${libgtk_common}"],
  }

  $libgtk = "libgtk2.0-0_2.24.28-1ubuntu1.1_amd64.deb"
  $libgtk_package = "libgtk2.0-0"
  @file {"${libgtk}":
    require    =>  File["${local_install_dir}"],
    path       =>  "${local_install_dir}${libgtk}",
    ensure     =>  present,
    source     =>  ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${libgtk}"]
  }
  @package {
    "${$libgtk_package}":
      ensure      => installed,
      provider    =>  'dpkg',
      source      =>  "${local_install_dir}${libgtk}",
      require     =>  [File["${libgtk}"],
        #          Package["${libgtk_common}"],
        Package["${libgtk_common_package}"]
      ]
  }
}