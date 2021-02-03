class pandoc::ubuntu::bionic {
  $package_type=$pandoc::package_type
  $puppet_file_dir=$pandoc::puppet_file_dir

  include linux::ubuntu::bionic::deps

  $fonts_lmodern_file_name = "fonts-lmodern_2.004.5-3_all.deb"
  $fonts_lmodern_package_name = "fonts-lmodern"
  @file { "${fonts_lmodern_file_name}":
    ensure => present,
    path   => "${local_install_dir}${fonts_lmodern_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${fonts_lmodern_file_name}",
  }
  @package { "${fonts_lmodern_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${fonts_lmodern_file_name}",
    require  => [
      File["${fonts_lmodern_file_name}"],
    ]
  }

  $tex_common_file_name = "tex-common_6.09_all.deb"
  $tex_common_package_name = "tex-common"
  @file { "${tex_common_file_name}":
    ensure => present,
    path   => "${local_install_dir}${tex_common_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${tex_common_file_name}",
  }
  @package { "${tex_common_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${tex_common_file_name}",
    require  => [
      File["${tex_common_file_name}"],
    ]
  }

  $libpaper1_file_name = "libpaper1_1.1.24+nmu5ubuntu1_amd64.deb"
  $libpaper1_package_name = "libpaper1"
  file { "${libpaper1_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libpaper1_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libpaper1_file_name}",
  }
  package { "${libpaper1_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libpaper1_file_name}",
    require  => [
      File["${libpaper1_file_name}"],
    ]
  }

  $libpaper_utils_file_name = "libpaper-utils_1.1.24+nmu5ubuntu1_amd64.deb"
  $libpaper_utils_package_name = "libpaper-utils"
  file { "${libpaper_utils_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libpaper_utils_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libpaper_utils_file_name}",
  }
  package { "${libpaper_utils_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libpaper_utils_file_name}",
    require  => [
      File["${libpaper_utils_file_name}"],
      Package["${libpaper1_package_name}"],
    ]
  }

  $xdg_utils_file_name = "xdg-utils_1.1.2-1ubuntu2.3_all.deb"
  $xdg_utils_package_name = "xdg-utils"
  file { "${xdg_utils_file_name}":
    ensure => present,
    path   => "${local_install_dir}${xdg_utils_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${xdg_utils_file_name}",
  }
  package { "${xdg_utils_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${xdg_utils_file_name}",
    require  => [
      File["${xdg_utils_file_name}"],
    ]
  }

  $libkpathsea6_file_name = "libkpathsea6_2017.20170613.44572-8ubuntu0.1_amd64.deb"
  $libkpathsea6_package_name = "libkpathsea6"
  file { "${libkpathsea6_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libkpathsea6_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libkpathsea6_file_name}",
  }
  package { "${libkpathsea6_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libkpathsea6_file_name}",
    require  => [
      File["${libkpathsea6_file_name}"],
    ]
  }

  $libptexenc1_file_name = "libptexenc1_2017.20170613.44572-8ubuntu0.1_amd64.deb"
  $libptexenc1_package_name = "libptexenc1"
  file { "${libptexenc1_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libptexenc1_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libptexenc1_file_name}",
  }
  package { "${libptexenc1_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libptexenc1_file_name}",
    require  => [
      File["${libptexenc1_file_name}"],
      Package["${libkpathsea6_package_name}"],
    ]
  }

  $libsynctex1_file_name = "libsynctex1_2017.20170613.44572-8ubuntu0.1_amd64.deb"
  $libsynctex1_package_name = "libsynctex1"
  file { "${libsynctex1_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libsynctex1_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libsynctex1_file_name}",
  }
  package { "${libsynctex1_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libsynctex1_file_name}",
    require  => [
      File["${libsynctex1_file_name}"],
    ]
  }

  $libtexlua52_file_name = "libtexlua52_2017.20170613.44572-8ubuntu0.1_amd64.deb"
  $libtexlua52_package_name = "libtexlua52"
  file { "${libtexlua52_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libtexlua52_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libtexlua52_file_name}",
  }
  package { "${libtexlua52_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libtexlua52_file_name}",
    require  => [
      File["${libtexlua52_file_name}"],
    ]
  }

  $libtexluajit2_file_name = "libtexluajit2_2017.20170613.44572-8ubuntu0.1_amd64.deb"
  $libtexluajit2_package_name = "libtexluajit2"
  file { "${libtexluajit2_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libtexluajit2_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libtexluajit2_file_name}",
  }
  package { "${libtexluajit2_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libtexluajit2_file_name}",
    require  => [
      File["${libtexluajit2_file_name}"],
    ]
  }

  $t1utils_file_name = "t1utils_1.41-2_amd64.deb"
  $t1utils_package_name = "t1utils"
  file { "${t1utils_file_name}":
    ensure => present,
    path   => "${local_install_dir}${t1utils_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${t1utils_file_name}",
  }
  package { "${t1utils_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${t1utils_file_name}",
    require  => [
      File["${t1utils_file_name}"],
    ]
  }

  $fonts_dejavu_core_file_name = "fonts-dejavu-core_2.37-1_all.deb"
  $fonts_dejavu_core_package_name = "fonts-dejavu-core"
  file { "${fonts_dejavu_core_file_name}":
    ensure => present,
    path   => "${local_install_dir}${fonts_dejavu_core_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${fonts_dejavu_core_file_name}",
  }
  package { "${fonts_dejavu_core_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${fonts_dejavu_core_file_name}",
    require  => [
      File["${fonts_dejavu_core_file_name}"],
    ]
  }

  $ttf_bitstream_vera_file_name = "ttf-bitstream-vera_1.10-8_all.deb"
  $ttf_bitstream_vera_package_name = "ttf-bitstream-vera"
  file { "${ttf_bitstream_vera_file_name}":
    ensure => present,
    path   => "${local_install_dir}${ttf_bitstream_vera_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${ttf_bitstream_vera_file_name}",
  }
  package { "${ttf_bitstream_vera_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${ttf_bitstream_vera_file_name}",
    require  => [
      File["${ttf_bitstream_vera_file_name}"],
    ]
  }

  $fonts_liberation_file_name = "fonts-liberation_1%3a1.07.4-7~18.04.1_all.deb"
  $fonts_liberation_package_name = "fonts-liberation"
  file { "${fonts_liberation_file_name}":
    ensure => present,
    path   => "${local_install_dir}${fonts_liberation_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${fonts_liberation_file_name}",
  }
  package { "${fonts_liberation_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${fonts_liberation_file_name}",
    require  => [
      File["${fonts_liberation_file_name}"],
    ]
  }

  $libgraphite2_3_file_name = "libgraphite2-3_1.3.11-2_amd64.deb"
  $libgraphite2_3_package_name = "libgraphite2-3"
  file { "${libgraphite2_3_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libgraphite2_3_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libgraphite2_3_file_name}",
  }
  package { "${libgraphite2_3_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libgraphite2_3_file_name}",
    require  => [
      File["${libgraphite2_3_file_name}"],
    ]
  }

  $fontconfig_config_file_name = "fontconfig-config_2.12.6-0ubuntu2_all.deb"
  $fontconfig_config_package_name = "fontconfig-config"
  file { "${fontconfig_config_file_name}":
    ensure => present,
    path   => "${local_install_dir}${fontconfig_config_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${fontconfig_config_file_name}",
  }
  package { "${fontconfig_config_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${fontconfig_config_file_name}",
    require  => [
      File["${fontconfig_config_file_name}"],
    ]
  }

  $libfontconfig1_file_name = "libfontconfig1_2.12.6-0ubuntu2_amd64.deb"
  $libfontconfig1_package_name = "libfontconfig1"
  file { "${libfontconfig1_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libfontconfig1_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libfontconfig1_file_name}",
  }
  package { "${libfontconfig1_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libfontconfig1_file_name}",
    require  => [
      File["${libfontconfig1_file_name}"],
      Package["${fontconfig_config_package_name}"],
    ]
  }

  $libpixman_1_0_file_name = "libpixman-1-0_0.34.0-2_amd64.deb"
  $libpixman_1_0_package_name = "libpixman-1-0"
  file { "${libpixman_1_0_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libpixman_1_0_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libpixman_1_0_file_name}",
  }
  package { "${libpixman_1_0_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libpixman_1_0_file_name}",
    require  => [
      File["${libpixman_1_0_file_name}"],
    ]
  }

  $libxcb_render0_file_name = "libxcb-render0_1.13-2~ubuntu18.04_amd64.deb"
  $libxcb_render0_package_name = "libxcb-render0"
  file { "${libxcb_render0_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libxcb_render0_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libxcb_render0_file_name}",
  }
  package { "${libxcb_render0_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libxcb_render0_file_name}",
    require  => [
      File["${libxcb_render0_file_name}"],
    ]
  }

  $libxcb_shm0_file_name = "libxcb-shm0_1.13-2~ubuntu18.04_amd64.deb"
  $libxcb_shm0_package_name = "libxcb-shm0"
  file { "${libxcb_shm0_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libxcb_shm0_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libxcb_shm0_file_name}",
  }
  package { "${libxcb_shm0_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libxcb_shm0_file_name}",
    require  => [
      File["${libxcb_shm0_file_name}"],
    ]
  }

  realize(
    Package["${linux::ubuntu::bionic::deps::libxrender1_package_name}"],
    File["${linux::ubuntu::bionic::deps::libxrender1_file_name}"]
  )
  # $libxrender1_file_name = "libxrender1_1%3a0.9.10-1_amd64.deb"
  # $libxrender1_package_name = "libxrender1"
  # file { "${libxrender1_file_name}":
  #   ensure => present,
  #   path   => "${local_install_dir}${libxrender1_file_name}",
  #   source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libxrender1_file_name}",
  # }
  # package { "${libxrender1_package_name}":
  #   ensure   => present,
  #   provider => dpkg,
  #   source   => "${local_install_dir}${libxrender1_file_name}",
  #   require  => [
  #     File["${libxrender1_file_name}"],
  #   ]
  # }

  $libcairo2_file_name = "libcairo2_1.15.10-2ubuntu0.1_amd64.deb"
  $libcairo2_package_name = "libcairo2"
  file { "${libcairo2_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libcairo2_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libcairo2_file_name}",
  }
  package { "${libcairo2_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libcairo2_file_name}",
    require  => [
      File["${libcairo2_file_name}"],
      Package["${libfontconfig1_package_name}"],
      Package["${libpixman_1_0_package_name}"],
      Package["${libxcb_render0_package_name}"],
      Package["${libxcb_shm0_package_name}"],
      Package["${linux::ubuntu::bionic::deps::libxrender1_package_name}"],
    ]
  }

  $libharfbuzz0b_file_name = "libharfbuzz0b_1.7.2-1ubuntu1_amd64.deb"
  $libharfbuzz0b_package_name = "libharfbuzz0b"
  file { "${libharfbuzz0b_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libharfbuzz0b_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libharfbuzz0b_file_name}",
  }
  package { "${libharfbuzz0b_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libharfbuzz0b_file_name}",
    require  => [
      File["${libharfbuzz0b_file_name}"],
    ]
  }

  $libharfbuzz_icu0_file_name = "libharfbuzz-icu0_1.7.2-1ubuntu1_amd64.deb"
  $libharfbuzz_icu0_package_name = "libharfbuzz-icu0"
  file { "${libharfbuzz_icu0_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libharfbuzz_icu0_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libharfbuzz_icu0_file_name}",
  }
  package { "${libharfbuzz_icu0_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libharfbuzz_icu0_file_name}",
    require  => [
      File["${libharfbuzz_icu0_file_name}"],
      Package["${libharfbuzz0b_package_name}"],
    ]
  }

  $libavahi_common_data_file_name = "libavahi-common-data_0.7-3.1ubuntu1.2_amd64.deb"
  $libavahi_common_data_package_name = "libavahi-common-data"
  file { "${libavahi_common_data_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libavahi_common_data_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libavahi_common_data_file_name}",
  }
  package { "${libavahi_common_data_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libavahi_common_data_file_name}",
    require  => [
      File["${libavahi_common_data_file_name}"],
    ]
  }

  $libavahi_common3_file_name = "libavahi-common3_0.7-3.1ubuntu1.2_amd64.deb"
  $libavahi_common3_package_name = "libavahi-common3"
  file { "${libavahi_common3_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libavahi_common3_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libavahi_common3_file_name}",
  }
  package { "${libavahi_common3_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libavahi_common3_file_name}",
    require  => [
      File["${libavahi_common3_file_name}"],
      Package["${libavahi_common_data_package_name}"],
    ]
  }

  $libavahi_client3_file_name = "libavahi-client3_0.7-3.1ubuntu1.2_amd64.deb"
  $libavahi_client3_package_name = "libavahi-client3"
  file { "${libavahi_client3_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libavahi_client3_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libavahi_client3_file_name}",
  }
  package { "${libavahi_client3_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libavahi_client3_file_name}",
    require  => [
      File["${libavahi_client3_file_name}"],
    ]
  }

  $libcups2_file_name = "libcups2_2.2.7-1ubuntu2.7_amd64.deb"
  $libcups2_package_name = "libcups2"
  file { "${libcups2_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libcups2_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libcups2_file_name}",
  }
  package { "${libcups2_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libcups2_file_name}",
    require  => [
      File["${libcups2_file_name}"],
      Package["${libavahi_common3_package_name}"],
      Package["${libavahi_client3_package_name}"],
    ]
  }

  $libcupsimage2_file_name = "libcupsimage2_2.2.7-1ubuntu2.7_amd64.deb"
  $libcupsimage2_package_name = "libcupsimage2"
  file { "${libcupsimage2_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libcupsimage2_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libcupsimage2_file_name}",
  }
  package { "${libcupsimage2_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libcupsimage2_file_name}",
    require  => [
      File["${libcupsimage2_file_name}"],
      Package["${libcups2_package_name}"],
    ]
  }

  $libijs_0_35_file_name = "libijs-0.35_0.35-13_amd64.deb"
  $libijs_0_35_package_name = "libijs-0.35"
  file { "${libijs_0_35_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libijs_0_35_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libijs_0_35_file_name}",
  }
  package { "${libijs_0_35_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libijs_0_35_file_name}",
    require  => [
      File["${libijs_0_35_file_name}"],
    ]
  }

  $libjbig2dec0_file_name = "libjbig2dec0_0.13-6_amd64.deb"
  $libjbig2dec0_package_name = "libjbig2dec0"
  file { "${libjbig2dec0_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libjbig2dec0_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libjbig2dec0_file_name}",
  }
  package { "${libjbig2dec0_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libjbig2dec0_file_name}",
    require  => [
      File["${libjbig2dec0_file_name}"],
    ]
  }

  $libjpeg_turbo8_file_name = "libjpeg-turbo8_1.5.2-0ubuntu5.18.04.3_amd64.deb"
  $libjpeg_turbo8_package_name = "libjpeg-turbo8"
  file { "${libjpeg_turbo8_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libjpeg_turbo8_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libjpeg_turbo8_file_name}",
  }
  package { "${libjpeg_turbo8_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libjpeg_turbo8_file_name}",
    require  => [
      File["${libjpeg_turbo8_file_name}"],
    ]
  }

  $libjpeg8_file_name = "libjpeg8_8c-2ubuntu8_amd64.deb"
  $libjpeg8_package_name = "libjpeg8"
  file { "${libjpeg8_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libjpeg8_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libjpeg8_file_name}",
  }
  package { "${libjpeg8_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libjpeg8_file_name}",
    require  => [
      File["${libjpeg8_file_name}"],
      Package["${libjpeg_turbo8_package_name}"],
    ]
  }

  $liblcms2_2_file_name = "liblcms2-2_2.9-1ubuntu0.1_amd64.deb"
  $liblcms2_2_package_name = "liblcms2-2"
  file { "${liblcms2_2_file_name}":
    ensure => present,
    path   => "${local_install_dir}${liblcms2_2_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${liblcms2_2_file_name}",
  }
  package { "${liblcms2_2_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${liblcms2_2_file_name}",
    require  => [
      File["${liblcms2_2_file_name}"],
    ]
  }

  $libjbig0_file_name = "libjbig0_2.1-3.1build1_amd64.deb"
  $libjbig0_package_name = "libjbig0"
  file { "${libjbig0_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libjbig0_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libjbig0_file_name}",
  }
  package { "${libjbig0_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libjbig0_file_name}",
    require  => [
      File["${libjbig0_file_name}"],
    ]
  }

  $libtiff5_file_name = "libtiff5_4.0.9-5ubuntu0.3_amd64.deb"
  $libtiff5_package_name = "libtiff5"
  file { "${libtiff5_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libtiff5_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libtiff5_file_name}",
  }
  package { "${libtiff5_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libtiff5_file_name}",
    require  => [
      File["${libtiff5_file_name}"],
      Package["${libjbig0_package_name}"],
    ]
  }

  $libgs9_common_file_name = "libgs9-common_9.26~dfsg+0-0ubuntu0.18.04.12_all.deb"
  $libgs9_common_package_name = "libgs9-common"
  file { "${libgs9_common_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libgs9_common_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libgs9_common_file_name}",
  }
  package { "${libgs9_common_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libgs9_common_file_name}",
    require  => [
      File["${libgs9_common_file_name}"],
      Package["${libfontconfig1_package_name}"],
    ]
  }

  $poppler_data_file_name = "poppler-data_0.4.8-2_all.deb"
  $poppler_data_package_name = "poppler-data"
  file { "${poppler_data_file_name}":
    ensure => present,
    path   => "${local_install_dir}${poppler_data_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${poppler_data_file_name}",
  }
  package { "${poppler_data_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${poppler_data_file_name}",
    require  => [
      File["${poppler_data_file_name}"],
    ]
  }

  $libgs9_file_name = "libgs9_9.26~dfsg+0-0ubuntu0.18.04.12_amd64.deb"
  $libgs9_package_name = "libgs9"
  file { "${libgs9_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libgs9_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libgs9_file_name}",
  }
  package { "${libgs9_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libgs9_file_name}",
    require  => [
      File["${libgs9_file_name}"],
      Package["${libcups2_package_name}"],
      Package["${libijs_0_35_package_name}"],
      Package["${libjbig2dec0_package_name}"],
      Package["${libjpeg8_package_name}"],
      Package["${liblcms2_2_package_name}"],
      Package["${libtiff5_package_name}"],
      Package["${libjbig0_package_name}"],
      Package["${libgs9_common_package_name}"],
      Package["${poppler_data_package_name}"],
    ]
  }

  $libnspr4_file_name = "libnspr4_2%3a4.18-1ubuntu1_amd64.deb"
  $libnspr4_package_name = "libnspr4"
  file { "${libnspr4_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libnspr4_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libnspr4_file_name}",
  }
  package { "${libnspr4_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libnspr4_file_name}",
    require  => [
      File["${libnspr4_file_name}"],
    ]
  }

  $libnss3_file_name = "libnss3_2%3a3.35-2ubuntu2.7_amd64.deb"
  $libnss3_package_name = "libnss3"
  file { "${libnss3_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libnss3_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libnss3_file_name}",
  }
  package { "${libnss3_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libnss3_file_name}",
    require  => [
      File["${libnss3_file_name}"],
      Package["${libnspr4_package_name}"],
    ]
  }

  $libpoppler73_file_name = "libpoppler73_0.62.0-2ubuntu2.10_amd64.deb"
  $libpoppler73_package_name = "libpoppler73"
  file { "${libpoppler73_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libpoppler73_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libpoppler73_file_name}",
  }
  package { "${libpoppler73_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libpoppler73_file_name}",
    require  => [
      File["${libpoppler73_file_name}"],
      Package["${libnss3_package_name}"],
      Package["${libnspr4_package_name}"],
      Package["${libfontconfig1_package_name}"],
    ]
  }

  $libpotrace0_file_name = "libpotrace0_1.14-2_amd64.deb"
  $libpotrace0_package_name = "libpotrace0"
  file { "${libpotrace0_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libpotrace0_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libpotrace0_file_name}",
  }
  package { "${libpotrace0_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libpotrace0_file_name}",
    require  => [
      File["${libpotrace0_file_name}"],
    ]
  }

  realize(Package["${linux::ubuntu::bionic::deps::x11_common_package_name}"],
    File["${linux::ubuntu::bionic::deps::x11_common_file_name}"]
  )

  # $x11_common_file_name = "x11-common_1%3a7.7+19ubuntu7.1_all.deb"
  # $x11_common_package_name = "x11-common"
  # file { "${x11_common_file_name}":
  #   ensure => present,
  #   path   => "${local_install_dir}${x11_common_file_name}",
  #   source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${x11_common_file_name}",
  # }
  # package { "${x11_common_package_name}":
  #   ensure   => present,
  #   provider => dpkg,
  #   source   => "${local_install_dir}${x11_common_file_name}",
  #   require  => [
  #     File["${x11_common_file_name}"],
  #   ]
  # }

  $libice6_file_name = "libice6_2%3a1.0.9-2_amd64.deb"
  $libice6_package_name = "libice6"
  file { "${libice6_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libice6_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libice6_file_name}",
  }
  package { "${libice6_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libice6_file_name}",
    require  => [
      File["${libice6_file_name}"],
      Package["${linux::ubuntu::bionic::deps::x11_common_package_name}"],
    ]
  }

  $libsm6_file_name = "libsm6_2%3a1.2.2-1_amd64.deb"
  $libsm6_package_name = "libsm6"
  file { "${libsm6_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libsm6_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libsm6_file_name}",
  }
  package { "${libsm6_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libsm6_file_name}",
    require  => [
      File["${libsm6_file_name}"],
      Package["${libice6_package_name}"],
    ]
  }

  $libxt6_file_name = "libxt6_1%3a1.1.5-1_amd64.deb"
  $libxt6_package_name = "libxt6"
  file { "${libxt6_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libxt6_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libxt6_file_name}",
  }
  package { "${libxt6_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libxt6_file_name}",
    require  => [
      File["${libxt6_file_name}"],
      Package["${libice6_package_name}"],
      Package["${libsm6_package_name}"],
    ]
  }

  $libxmu6_file_name = "libxmu6_2%3a1.1.2-2_amd64.deb"
  $libxmu6_package_name = "libxmu6"
  file { "${libxmu6_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libxmu6_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libxmu6_file_name}",
  }
  package { "${libxmu6_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libxmu6_file_name}",
    require  => [
      File["${libxmu6_file_name}"],
      Package["${libxt6_package_name}"],
    ]
  }

  $libxpm4_file_name = "libxpm4_1%3a3.5.12-1_amd64.deb"
  $libxpm4_package_name = "libxpm4"
  file { "${libxpm4_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libxpm4_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libxpm4_file_name}",
  }
  package { "${libxpm4_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libxpm4_file_name}",
    require  => [
      File["${libxpm4_file_name}"],
    ]
  }

  $libxaw7_file_name = "libxaw7_2%3a1.0.13-1_amd64.deb"
  $libxaw7_package_name = "libxaw7"
  file { "${libxaw7_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libxaw7_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libxaw7_file_name}",
  }
  package { "${libxaw7_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libxaw7_file_name}",
    require  => [
      File["${libxaw7_file_name}"],
      Package["${libxmu6_package_name}"],
      Package["${libxpm4_package_name}"],
    ]
  }

  realize(
    Package["${linux::ubuntu::bionic::deps::libxi6_package_name}"],
    File["${linux::ubuntu::bionic::deps::libxi6_file_name}"]
  )
  # $libxi6_file_name = "libxi6_2%3a1.7.9-1_amd64.deb"
  # $libxi6_package_name = "libxi6"
  # file { "${libxi6_file_name}":
  #   ensure => present,
  #   path   => "${local_install_dir}${libxi6_file_name}",
  #   source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libxi6_file_name}",
  # }
  # package { "${libxi6_package_name}":
  #   ensure   => present,
  #   provider => dpkg,
  #   source   => "${local_install_dir}${libxi6_file_name}",
  #   require  => [
  #     File["${libxi6_file_name}"],
  #   ]
  # }

  $libzzip_0_13_file_name = "libzzip-0-13_0.13.62-3.1ubuntu0.18.04.1_amd64.deb"
  $libzzip_0_13_package_name = "libzzip-0-13"
  file { "${libzzip_0_13_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libzzip_0_13_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libzzip_0_13_file_name}",
  }
  package { "${libzzip_0_13_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libzzip_0_13_file_name}",
    require  => [
      File["${libzzip_0_13_file_name}"],
    ]
  }

  $texlive_binaries_file_name = "texlive-binaries_2017.20170613.44572-8ubuntu0.1_amd64.deb"
  $texlive_binaries_package_name = "texlive-binaries"
  @file { "${texlive_binaries_file_name}":
    ensure => present,
    path   => "${local_install_dir}${texlive_binaries_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${texlive_binaries_file_name}",
  }
  @package { "${texlive_binaries_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${texlive_binaries_file_name}",
    require  => [
      File["${texlive_binaries_file_name}"],
      Package["${libptexenc1_package_name}"],
      Package["${libsynctex1_package_name}"],
      Package["${libtexlua52_package_name}"],
      Package["${libtexluajit2_package_name}"],
      Package["${t1utils_package_name}"],
      Package["${libcairo2_package_name}"],
      Package["${libfontconfig1_package_name}"],
      Package["${libgraphite2_3_package_name}"],
      Package["${libgs9_package_name}"],
      Package["${libharfbuzz_icu0_package_name}"],
      Package["${libcups2_package_name}"],
      Package["${libcupsimage2_package_name}"],
      Package["${libpoppler73_package_name}"],
      Package["${libpotrace0_package_name}"],
      Package["${libxaw7_package_name}"],
      Package["${linux::ubuntu::bionic::deps::libxi6_package_name}"],
    ]
  }

  $texlive_base_file_name = "texlive-base_2017.20180305-1_all.deb"
  $texlive_base_package_name = "texlive-base"
  @file { "${texlive_base_file_name}":
    ensure => present,
    path   => "${local_install_dir}${texlive_base_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${texlive_base_file_name}",
  }
  @package { "${texlive_base_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${texlive_base_file_name}",
    require  => [
      File["${texlive_base_file_name}"],
      Package["${libpaper_utils_package_name}"],
      Package["${xdg_utils_package_name}"],
      Package["${texlive_binaries_package_name}"],
    ]
  }
}

define pandoc::ubuntu::bionic::texlive_fonts_recommended {
  $package_type = $pandoc::package_type
  $puppet_file_dir = $pandoc::puppet_file_dir

  include pandoc::ubuntu::bionic

  realize(File["$pandoc::ubuntu::bionic::texlive_base_file_name"])
  realize(Package["${pandoc::ubuntu::bionic::texlive_base_package_name}"])

  realize(File["$pandoc::ubuntu::bionic::texlive_binaries_file_name"])
  realize(Package["${pandoc::ubuntu::bionic::texlive_binaries_package_name}"])

  realize(File["${pandoc::ubuntu::bionic::tex_common_file_name}"])
  realize(Package["${pandoc::ubuntu::bionic::tex_common_package_name}"])

  $texlive_fonts_recommended_file_name = "texlive-fonts-recommended_2017.20180305-1_all.deb"
  $texlive_fonts_recommended_package_name = "texlive-fonts-recommended"
  file { "${texlive_fonts_recommended_file_name}":
    ensure => present,
    path   => "${local_install_dir}${texlive_fonts_recommended_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${texlive_fonts_recommended_file_name}",
  }
  package { "${texlive_fonts_recommended_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${texlive_fonts_recommended_file_name}",
    require  => [
      File["${texlive_fonts_recommended_file_name}"],
      Package["${pandoc::ubuntu::bionic::tex_common_package_name}"],
      Package["${pandoc::ubuntu::bionic::texlive_base_package_name}"],
    ]
  }
}

define pandoc::ubuntu::bionic::texlive_latex_extra {
  $package_type=$pandoc::package_type
  $puppet_file_dir=$pandoc::puppet_file_dir
  include pandoc::ubuntu::bionic
  include python

  realize(File["${pandoc::ubuntu::bionic::tex_common_file_name}"])
  realize(Package["${pandoc::ubuntu::bionic::tex_common_package_name}"])

  realize(File["${pandoc::ubuntu::bionic::texlive_binaries_file_name}"])
  realize(Package["${pandoc::ubuntu::bionic::texlive_binaries_package_name}"])

  realize(File["${pandoc::ubuntu::bionic::texlive_base_file_name}"])
  realize(Package["${pandoc::ubuntu::bionic::texlive_base_package_name}"])

  realize(File["${pandoc::ubuntu::bionic::fonts_lmodern_file_name}"])
  realize(Package["${pandoc::ubuntu::bionic::fonts_lmodern_package_name}"])

  realize(Python::Ubuntu::Bionic["virtual"])
  realize(File["python_2.7.15~rc1-1_amd64.deb"])
  realize(Package["python"])

  $preview_latex_style_file_name = "preview-latex-style_11.91-1ubuntu1_all.deb"
  $preview_latex_style_package_name = "preview-latex-style"
  file { "${preview_latex_style_file_name}":
    ensure => present,
    path   => "${local_install_dir}${preview_latex_style_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${preview_latex_style_file_name}",
  }
  package { "${preview_latex_style_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${preview_latex_style_file_name}",
    require  => [
      File["${preview_latex_style_file_name}"],
    ]
  }

  $texlive_latex_base_file_name = "texlive-latex-base_2017.20180305-1_all.deb"
  $texlive_latex_base_package_name = "texlive-latex-base"
  file { "${texlive_latex_base_file_name}":
    ensure => present,
    path   => "${local_install_dir}${texlive_latex_base_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${texlive_latex_base_file_name}",
  }
  package { "${texlive_latex_base_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${texlive_latex_base_file_name}",
    require  => [
      File["${texlive_latex_base_file_name}"],
      Package["${pandoc::ubuntu::bionic::fonts_lmodern_package_name}"],
    ]
  }

  $texlive_latex_recommended_file_name = "texlive-latex-recommended_2017.20180305-1_all.deb"
  $texlive_latex_recommended_package_name = "texlive-latex-recommended"
  file { "${texlive_latex_recommended_file_name}":
    ensure => present,
    path   => "${local_install_dir}${texlive_latex_recommended_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${texlive_latex_recommended_file_name}",
  }
  package { "${texlive_latex_recommended_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${texlive_latex_recommended_file_name}",
    require  => [
      File["${texlive_latex_recommended_file_name}"],
      Package["${texlive_latex_base_package_name}"],
    ]
  }

  $texlive_pictures_file_name = "texlive-pictures_2017.20180305-1_all.deb"
  $texlive_pictures_package_name = "texlive-pictures"
  file { "${texlive_pictures_file_name}":
    ensure => present,
    path   => "${local_install_dir}${texlive_pictures_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${texlive_pictures_file_name}",
  }
  package { "${texlive_pictures_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${texlive_pictures_file_name}",
    require  => [
      File["${texlive_pictures_file_name}"],
      Package["python"],
    ]
  }

  $texlive_latex_extra_file_name = "texlive-latex-extra_2017.20180305-2_all.deb"
  $texlive_latex_extra_package_name = "texlive-latex-extra"
  file { "${texlive_latex_extra_file_name}":
    ensure => present,
    path   => "${local_install_dir}${texlive_latex_extra_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${texlive_latex_extra_file_name}",
  }
  package { "${texlive_latex_extra_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${texlive_latex_extra_file_name}",
    require  => [
      File["${texlive_latex_extra_file_name}"],
      Package["${pandoc::ubuntu::bionic::texlive_base_package_name}"],
      Package["${pandoc::ubuntu::bionic::tex_common_package_name}"],
      Package["${pandoc::ubuntu::bionic::texlive_binaries_package_name}"],
      Package["python"],
      Package["${preview_latex_style_package_name}"],
      Package["${texlive_latex_recommended_package_name}"],
      Package["${texlive_pictures_package_name}"],
    ]
  }
}

define pandoc::ubuntu::bionic::lmodern {
  $package_type=$pandoc::package_type
  $puppet_file_dir=$pandoc::puppet_file_dir
  include pandoc::ubuntu::bionic

  realize(File["${pandoc::ubuntu::bionic::tex_common_file_name}"])
  realize(Package["tex-common"])

  realize(File["${pandoc::ubuntu::bionic::fonts_lmodern_file_name}"])
  realize(Package["${pandoc::ubuntu::bionic::fonts_lmodern_package_name}"])

  $lmodern_file_name = "lmodern_2.004.5-3_all.deb"
  $lmodern_package_name = "lmodern"
  file { "${lmodern_file_name}":
    ensure => present,
    path   => "${local_install_dir}${lmodern_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${lmodern_file_name}",
  }
  package { "${lmodern_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${lmodern_file_name}",
    require  => [
      File["${lmodern_file_name}"],
      Package["${pandoc::ubuntu::bionic::tex_common_package_name}"],
    ]
  }

}
