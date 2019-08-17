define java::ubuntu::xenial(
  $java_package = undef,
  $major_version = undef,
  $update_version = unde
) {
  $local_install_path = "/etc/puppet/"
  $local_install_dir = "${local_install_path}installers/"
  $puppet_file_dir = "modules/java/"
  $platform = "amd64"

  if (versioncmp("${major_version}", "seven") == 0) {

    $libatk1_data_name = "libatk1.0-data"
    $libatk1_data_version = "2.18.0-1"
    $libatk1_data_file_name = "${libatk1_data_name}_${libatk1_data_version}_all.deb"

    file { "${libatk1_data_file_name}":
      require => File["${local_install_dir}"],
      path    => "${local_install_dir}${libatk1_data_file_name}",
      ensure  => present,
      source  => ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${
        libatk1_data_file_name}"]
    }
    package {
      "${libatk1_data_name}":
        ensure   => installed,
        provider => 'dpkg',
        source   => "${local_install_dir}${libatk1_data_file_name}",
        require  => File["${libatk1_data_file_name}"],
        before   => Package["${java_package}"]
    }

    $libatk1_name = "libatk1.0-0"
    $libatk1_version = "2.18.0-1"
    $libatk1_file_name = "${libatk1_name}_${libatk1_version}_${platform}.deb"

    file { "${libatk1_file_name}":
      require => File["${local_install_dir}"],
      path    => "${local_install_dir}${libatk1_file_name}",
      ensure  => present,
      source  => ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${libatk1_file_name}"
      ]
    }
    package {
      "${libatk1_name}":
        ensure   => installed,
        provider => 'dpkg',
        source   => "${local_install_dir}${libatk1_file_name}",
        require  => [
          File["${libatk1_file_name}"],
          Package["${libatk1_data_name}"]
        ],
        before   => Package["${java_package}"]
    }

    # libasound2-data_1.1.0-0ubuntu1_all.deb
    $libasound2_data_name = "libasound2-data"
    $libasound2_data_version = "1.1.0-0ubuntu1"
    $libasound2_data_file_name = "${libasound2_data_name}_${libasound2_data_version}_all.deb"

    file { "${libasound2_data_file_name}":
      require => File["${local_install_dir}"],
      path    => "${local_install_dir}${libasound2_data_file_name}",
      ensure  => present,
      source  => ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${
        libasound2_data_file_name}"]
    }
    package {
      "${libasound2_data_name}":
        ensure   => installed,
        provider => 'dpkg',
        source   => "${local_install_dir}${libasound2_data_file_name}",
        require  => File["${libasound2_data_file_name}"],
        before   => Package["${java_package}"]
    }

    # libasound2_1.1.0-0ubuntu1_amd64.deb
    $libasound2_name = "libasound2"
    $libasound2_version = "1.1.0-0ubuntu1"
    $libasound2_file_name = "${libasound2_name}_${libasound2_version}_${platform}.deb"

    file { "${libasound2_file_name}":
      require => File["${local_install_dir}"],
      path    => "${local_install_dir}${libasound2_file_name}",
      ensure  => present,
      source  => ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${
        libasound2_file_name}"]
    }
    package {
      "${libasound2_name}":
        ensure   => installed,
        provider => 'dpkg',
        source   => "${local_install_dir}${libasound2_file_name}",
        require  => [
          File["${libasound2_file_name}"],
          Package["${libasound2_data_name}"]
        ],
        before   => Package["${java_package}"]
    }

    # needs: xfonts-utils gsfonts
    $gsfonts_x11_name = "gsfonts-x11"
    $gsfonts_x11_version = "0.24"
    $gsfonts_x11_file_name = "${gsfonts_x11_name}_${gsfonts_x11_version}_all.deb"

    file { "${gsfonts_x11_file_name}":
      require => File["${local_install_dir}"],
      path    => "${local_install_dir}${gsfonts_x11_file_name}",
      ensure  => present,
      source  => ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${
        gsfonts_x11_file_name}"]
    }
    package {
      "${gsfonts_x11_name}":
        ensure   => installed,
        provider => 'dpkg',
        source   => "${local_install_dir}${gsfonts_x11_file_name}",
        require  => File["${gsfonts_x11_file_name}"],
        before   => Package["${java_package}"]
    }

    $fontconfig_config_name = "fontconfig-config"
    $fontconfig_config_version = "2.11.94-0ubuntu1.1"
    $fontconfig_config_file_name = "${fontconfig_config_name}_${fontconfig_config_version}_all.deb"

    file { "${fontconfig_config_file_name}":
      require => File["${local_install_dir}"],
      path    => "${local_install_dir}${fontconfig_config_file_name}",
      ensure  => present,
      source  => ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${
        fontconfig_config_file_name}"]
    }
    package {
      "${fontconfig_config_name}":
        ensure   => installed,
        provider => 'dpkg',
        source   => "${local_install_dir}${fontconfig_config_file_name}",
        require  => [
          File["${fontconfig_config_file_name}"],
          Package["${gsfonts_x11_name}"]
        ],
        before   => Package["${java_package}"]
    }
    # libfontconfig1
    $libfontconfig1_name = "libfontconfig1"
    $libfontconfig1_version = "2.11.94-0ubuntu1.1"
    $libfontconfig1_file_name = "${libfontconfig1_name}_${libfontconfig1_version}_${platform}.deb"

    file { "${libfontconfig1_file_name}":
      require => File["${local_install_dir}"],
      path    => "${local_install_dir}${libfontconfig1_file_name}",
      ensure  => present,
      source  => ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${
        libfontconfig1_file_name}"]
    }
    package {
      "${libfontconfig1_name}":
        ensure   => installed,
        provider => 'dpkg',
        source   => "${local_install_dir}${libfontconfig1_file_name}",
        require  => [
          File["${libfontconfig1_file_name}"],
          Package["${fontconfig_config_name}"]
        ],
        before   => Package["${java_package}"]
    }

    $libpixman_1_0_name = "libpixman-1-0"
    $libpixman_1_0_version = "0.33.6-1"
    $libpixman_1_0_file_name = "${libpixman_1_0_name}_${libpixman_1_0_version}_${platform}.deb"

    file { "${libpixman_1_0_file_name}":
      require => File["${local_install_dir}"],
      path    => "${local_install_dir}${libpixman_1_0_file_name}",
      ensure  => present,
      source  => ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${
        libpixman_1_0_file_name}"]
    }
    package {
      "${libpixman_1_0_name}":
        ensure   => installed,
        provider => 'dpkg',
        source   => "${local_install_dir}${libpixman_1_0_file_name}",
        require  => File["${libpixman_1_0_file_name}"],
        before   => Package["${java_package}"]
    }

    $libxcb_render0_name = "libxcb-render0"
    $libxcb_render0_version = "1.11.1-1ubuntu1"
    $libxcb_render0_file_name = "${libxcb_render0_name}_${libxcb_render0_version}_${platform}.deb"

    file { "${libxcb_render0_file_name}":
      require => File["${local_install_dir}"],
      path    => "${local_install_dir}${libxcb_render0_file_name}",
      ensure  => present,
      source  => ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${
        libxcb_render0_file_name}"]
    }
    package {
      "${libxcb_render0_name}":
        ensure   => installed,
        provider => 'dpkg',
        source   => "${local_install_dir}${libxcb_render0_file_name}",
        require  => File["${libxcb_render0_file_name}"],
        before   => Package["${java_package}"]
    }

    $libxcb_shm0_name = "libxcb-shm0"
    $libxcb_shm0_version = "1.11.1-1ubuntu1"
    $libxcb_shm0_file_name = "${libxcb_shm0_name}_${libxcb_shm0_version}_${platform}.deb"

    file { "${libxcb_shm0_file_name}":
      require => File["${local_install_dir}"],
      path    => "${local_install_dir}${libxcb_shm0_file_name}",
      ensure  => present,
      source  => ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${
        libxcb_shm0_file_name}"]
    }
    package {
      "${libxcb_shm0_name}":
        ensure   => installed,
        provider => 'dpkg',
        source   => "${local_install_dir}${libxcb_shm0_file_name}",
        require  => File["${libxcb_shm0_file_name}"],
        before   => Package["${java_package}"]
    }

    $libxrender1_name = "libxrender1"
    $libxrender1_version = "1%3a0.9.9-0ubuntu1"
    $libxrender1_file_name = "${libxrender1_name}_${libxrender1_version}_${platform}.deb"

    file { "${libxrender1_file_name}":
      require => File["${local_install_dir}"],
      path    => "${local_install_dir}${libxrender1_file_name}",
      ensure  => present,
      source  => ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${
        libxrender1_file_name}"]
    }
    package {
      "${libxrender1_name}":
        ensure   => installed,
        provider => 'dpkg',
        source   => "${local_install_dir}${libxrender1_file_name}",
        require  => File["${libxrender1_file_name}"],
        before   => Package["${java_package}"]
    }

    # libcairo2_1.14.6-1_amd64.deb
    $libcairo2_name = "libcairo2"
    $libcairo2_version = "1.14.6-1"
    $libcairo2_file_name = "${libcairo2_name}_${libcairo2_version}_${platform}.deb"

    file { "${libcairo2_file_name}":
      require => File["${local_install_dir}"],
      path    => "${local_install_dir}${libcairo2_file_name}",
      ensure  => present,
      source  => ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${libcairo2_file_name
      }"]
    }
    package {
      "${libcairo2_name}":
        ensure   => installed,
        provider => 'dpkg',
        source   => "${local_install_dir}${libcairo2_file_name}",
        require  => [
          File["${libcairo2_file_name}"],
          Package["${libfontconfig1_name}"],
          Package["${libpixman_1_0_name}"],
          Package["${libxcb_render0_name}"],
          Package["${libxcb_shm0_name}"],
          Package["${libxrender1_name}"]
        ],
        before   => Package["${java_package}"]
    }

    # libxcb_render0_2.11.94-0ubuntu1.1_amd64.deb
    # libgdk-pixbuf2.0-0_2.32.2-1ubuntu1.6_amd64.deb
    # libgl1-mesa-glx_18.0.5-0ubuntu0~16.04.1_amd64.deb
    # libgtk2.0-0_2.24.30-1ubuntu1.16.04.2_amd64.deb
    # libpango-1.0-0_1.38.1-1_amd64.deb
    # libpangocairo-1.0-0_1.38.1-1_amd64.deb
  } elsif (versioncmp("${major_version}", "six") == 0) {
    $libxi6_name = "libxi6"
    $libxi6_version = "2%3a1.7.6-1"
    $libxi6_file_name = "${libxi6_name}_${libxi6_version}_${platform}.deb"

    file { "${libxi6_file_name}":
      require => File["${local_install_dir}"],
      path    => "${local_install_dir}${libxi6_file_name}",
      ensure  => present,
      source  => ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${libxi6_file_name}"]
    }
    package {
      "${libxi6_name}":
        ensure   => installed,
        provider => 'dpkg',
        source   => "${local_install_dir}${libxi6_file_name}",
        require  => File["${libxi6_file_name}"],
        before   => Package["${java_package}"]
    }

    $x11_common_name = "x11-common"
    $x11_common_version = "1%3a7.7+13ubuntu3.1"
    $x11_common_file_name = "${x11_common_name}_${x11_common_version}_all.deb"

    file { "${x11_common_file_name}":
      require => File["${local_install_dir}"],
      path    => "${local_install_dir}${x11_common_file_name}",
      ensure  => present,
      source  => ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${
        x11_common_file_name}"]
    }
    package {
      "${x11_common_name}":
        ensure   => installed,
        provider => 'dpkg',
        source   => "${local_install_dir}${x11_common_file_name}",
        require  => File["${x11_common_file_name}"],
        before   => Package["${java_package}"]
    }

    $libice6_name = "libice6"
    $libice6_version = "2%3a1.0.9-1"
    $libice6_file_name = "${libice6_name}_${libice6_version}_${platform}.deb"

    file { "${libice6_file_name}":
      require => File["${local_install_dir}"],
      path    => "${local_install_dir}${libice6_file_name}",
      ensure  => present,
      source  => ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${libice6_file_name}"
      ]
    }
    package {
      "${libice6_name}":
        ensure   => installed,
        provider => 'dpkg',
        source   => "${local_install_dir}${libice6_file_name}",
        require  => File["${libice6_file_name}"],
        before   => Package["${java_package}"]
    }

    $libsm6_name = "libsm6"
    $libsm6_version = "2%3a1.2.2-1"
    $libsm6_file_name = "${libsm6_name}_${libsm6_version}_${platform}.deb"

    file { "${libsm6_file_name}":
      require => File["${local_install_dir}"],
      path    => "${local_install_dir}${libsm6_file_name}",
      ensure  => present,
      source  => ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${libsm6_file_name}"]
    }
    package {
      "${libsm6_name}":
        ensure   => installed,
        provider => 'dpkg',
        source   => "${local_install_dir}${libsm6_file_name}",
        require  => [
          File["${libsm6_file_name}"],
          Package["${libice6_name}"]
        ],
        before   => Package["${java_package}"]
    }

    $libxt6_name = "libxt6"
    $libxt6_version = "1%3a1.1.5-0ubuntu1"
    $libxt6_file_name = "${libxt6_name}_${libxt6_version}_${platform}.deb"

    file { "${libxt6_file_name}":
      require => File["${local_install_dir}"],
      path    => "${local_install_dir}${libxt6_file_name}",
      ensure  => present,
      source  => ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${libxt6_file_name}"]
    }
    package {
      "${libxt6_name}":
        ensure   => installed,
        provider => 'dpkg',
        source   => "${local_install_dir}${libxt6_file_name}",
        require  => [
          File["${libxt6_file_name}"],
          Package["${libice6_name}"],
          Package["${libsm6_name}"]
        ],
        before   => Package["${java_package}"]
    }

    $libxtst6_name = "libxtst6"
    $libxtst6_version = "2%3a1.2.2-1"
    $libxtst6_file_name = "${libxtst6_name}_${libxtst6_version}_${platform}.deb"

    file { "${libxtst6_file_name}":
      require => File["${local_install_dir}"],
      path    => "${local_install_dir}${libxtst6_file_name}",
      ensure  => present,
      source  => ["puppet:///${puppet_file_dir}${::operatingsystem}/${::operatingsystemmajrelease}/${libxtst6_file_name}
        "]
    }
    package {
      "${libxtst6_name}":
        ensure   => installed,
        provider => 'dpkg',
        source   => "${local_install_dir}${libxtst6_file_name}",
        require  => [
          File["${libxtst6_file_name}"],
        ],
        before   => Package["${java_package}"]
    }
  } elsif ((versioncmp("${major_version}", "8") == 0)
    or (versioncmp("${major_version}", "7") == 0)){
    $jvm_home_directory = "/usr/lib/jvm/"
    $major_version_home_directory = "${jvm_home_directory}jdk-${major_version}-oracle-x64/"
    file { ["${jvm_home_directory}","${major_version_home_directory}"]:
      ensure => directory,
    }

    $java_archive_file_name = "jdk-${major_version}u${update_version}-linux-x64.tar.gz"
    file { $java_archive_file_name:
      path    => "${major_version_home_directory}${java_archive_file_name}",
      source  => ["puppet:///${puppet_file_dir}${::operatingsystem}/${java_archive_file_name}"],
      require => File["${major_version_home_directory}"]
    }

    $decompress_exec_name = "Decompress and untar Java ${major_version}"
    exec { $decompress_exec_name:
      path    => "/bin/",
      command => "tar --strip-components=1 -C ${major_version_home_directory} -xvzf ${major_version_home_directory}${java_archive_file_name}",
      require => [
        File["${major_version_home_directory}"],
        File["${java_archive_file_name}"]
      ]
    }
    exec { "Remove archive":
      path    => "/bin/",
      command => "rm ${jvm_home_directory}/${java_archive_file_name}",
      onlyif  => "/usr/bin/find ${jvm_home_directory}/${java_archive_file_name}",
      require => [
        File["${java_archive_file_name}"],
        Exec["${decompress_exec_name}"]
      ]
    }
    file  {"/usr/local/share/man/man1":
      path => "/usr/local/share/man/man1",
      ensure => directory,
      require => File["${java_archive_file_name}"]
    }
  } elsif (versioncmp("${major_version}", "6") == 0) {
    $jvm_home_directory = "/usr/lib/jvm/"
    $major_version_home_directory = "${jvm_home_directory}jdk-${major_version}-oracle-x64"
    file { ["${jvm_home_directory}", "${major_version_home_directory}"]:
      ensure => directory,
    }
    exec { "Remove ${major_version_home_directory}":
      path    => "/bin/",
      command => "rm -rf ${major_version_home_directory}",
      onlyif  => "/usr/bin/find ${major_version_home_directory}",
      require => [
        File["${jvm_home_directory}"]
      ],
      before => [
        File["${major_version_home_directory}"]
      ]
    }

    $java_archive_file_name = "jdk-${major_version}u${update_version}-linux-x64.bin"
    file { $java_archive_file_name:
      path    => "${jvm_home_directory}${java_archive_file_name}",
      source  => ["puppet:///${puppet_file_dir}${::operatingsystem}/${java_archive_file_name}"],
      require => File["${jvm_home_directory}"]
    }

    $run_bin_exec_name = "Run Java ${major_version} .bin file"
    exec { $run_bin_exec_name:
      path    => "/bin/",
      cwd     => "${jvm_home_directory}",
      command => "bash ${java_archive_file_name}",
      require => [
        File["${jvm_home_directory}"],
        File["${java_archive_file_name}"]
      ]
    }

    $move_exec_name = "Move Java ${major_version} .bin directory"
    exec { $move_exec_name:
      path    => "/bin/",
      cwd     => "${jvm_home_directory}",
      command => "mv jdk1.${major_version}.0_${update_version}/* ${major_version_home_directory}",
      require => [
        File["${jvm_home_directory}"],
        File["${java_archive_file_name}"],
        Exec["${run_bin_exec_name}"]
      ]
    }

    exec { "Remove bin file":
      path    => "/bin/",
      command => "rm -rf ${jvm_home_directory}/${java_archive_file_name} ${jvm_home_directory}jdk1.${major_version}.0_${update_version}",
      onlyif  => "/usr/bin/find ${jvm_home_directory}/${java_archive_file_name}",
      require => [
        File["${java_archive_file_name}"],
        Exec["${run_bin_exec_name}"],
        Exec["${move_exec_name}"]
      ]
    }
    file  {"/usr/local/share/man/man1":
      path => "/usr/local/share/man/man1",
      ensure => directory,
      require => File["${java_archive_file_name}"]
    }
  }
}