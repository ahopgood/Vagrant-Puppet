define pandoc::ubuntu::xenial::texlive_fonts_recommended {
  $package_type=$pandoc::package_type
  $puppet_file_dir=$pandoc::puppet_file_dir

  $texlive_base_file_name = "texlive-base_2015.20160320-1ubuntu0.1_all.${package_type}"
  file { "${texlive_base_file_name}":
    ensure => present,
    path   => "${local_install_dir}${texlive_base_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${texlive_base_file_name}",
  }
  package { "texlive-base":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${texlive_base_file_name}",
    require  => [File["${texlive_base_file_name}"],
      Package["texlive-binaries"],
      Package["xdg-utils"],
      # Package["luatex"],
      Package["libpaper-utils"]
    ]
  }

  $libpaper_utils_file_name = "libpaper-utils_1.1.24+nmu4ubuntu1_${architecture}.${package_type}"
  file { "${libpaper_utils_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libpaper_utils_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libpaper_utils_file_name}",
  }
  package { "libpaper-utils":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libpaper_utils_file_name}",
    require  => [
      File["${libpaper_utils_file_name}"],
      Package["libpaper1"]
    ]
  }

  $libpaper1_file_name = "libpaper1_1.1.24+nmu4ubuntu1_${architecture}.${package_type}"
  file { "${libpaper1_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libpaper1_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libpaper1_file_name}",
  }
  package { "libpaper1":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libpaper1_file_name}",
    require  => [File["${libpaper1_file_name}"]]
  }

  $texlive_binaries_file_name = "texlive-binaries_2015.20160222.37495-1ubuntu0.1_${architecture}.${package_type}"
  file { "${texlive_binaries_file_name}":
    ensure => present,
    path   => "${local_install_dir}${texlive_binaries_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${
      texlive_binaries_file_name}",
  }
  package { "texlive-binaries":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${texlive_binaries_file_name}",
    require  => [File["${texlive_binaries_file_name}"],
      Package["libptexenc1"],
      Package["libsynctex1"],
      Package["libtexlua52"],
      Package["libtexluajit2"],
      Package["t1utils"],
      Package["libgraphite2-3"],
      Package["libgs9"],
      Package["libharfbuzz-icu0"],
      Package["libharfbuzz0b"],
      Package["libpoppler58"],
      Package["libpotrace0"],
      Package["libxaw7"],
      Package["libxi6"],
      Package["libxmu6"],
      Package["libzzip-0-13"],
    ]
  }

  $xdg_utils_file_name = "xdg-utils_1.1.0~rc1-2ubuntu7.1_all.${package_type}"
  file { "${xdg_utils_file_name}":
    ensure => present,
    path   => "${local_install_dir}${xdg_utils_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${xdg_utils_file_name}",
  }
  package { "xdg-utils":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${xdg_utils_file_name}",
    require  => [File["${xdg_utils_file_name}"]]
  }

  $libptexenc1_file_name = "libptexenc1_2015.20160222.37495-1ubuntu0.1_amd64.deb"
  file {"${libptexenc1_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libptexenc1_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libptexenc1_file_name}"
  }
  package { "libptexenc1":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libptexenc1_file_name}",
    require  => [File["${libptexenc1_file_name}"]]
  }

  $libsynctex1_file_name = "libsynctex1_2015.20160222.37495-1ubuntu0.1_amd64.deb"
  file {"${libsynctex1_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libsynctex1_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libsynctex1_file_name}"
  }
  package { "libsynctex1":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libsynctex1_file_name}",
    require  => [File["${libsynctex1_file_name}"]]
  }

  $libtexlua52_file_name = "libtexlua52_2015.20160222.37495-1ubuntu0.1_amd64.deb"
  file {"${libtexlua52_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libtexlua52_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libtexlua52_file_name}"
  }
  package { "libtexlua52":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libtexlua52_file_name}",
    require  => [File["${libtexlua52_file_name}"]]
  }

  $libtexluajit2_file_name = "libtexluajit2_2015.20160222.37495-1ubuntu0.1_amd64.deb"
  file {"${libtexluajit2_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libtexluajit2_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libtexluajit2_file_name}"
  }
  package { "libtexluajit2":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libtexluajit2_file_name}",
    require  => [File["${libtexluajit2_file_name}"]]
  }

  $libzzip_0_13_file_name = "libzzip-0-13_0.13.62-3ubuntu0.16.04.2_amd64.deb"
  file {"${libzzip_0_13_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libzzip_0_13_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libzzip_0_13_file_name}"
  }
  package { "libzzip-0-13":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libzzip_0_13_file_name}",
    require  => [File["${libzzip_0_13_file_name}"]]
  }


  $t1utils_file_name = "t1utils_1.39-2_amd64.deb"
  file {"${t1utils_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${t1utils_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${t1utils_file_name}"
  }
  package { "t1utils":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${t1utils_file_name}",
    require  => [File["${t1utils_file_name}"]]
  }

  $libgraphite2_3_file_name = "libgraphite2-3_1.3.10-0ubuntu0.16.04.1_amd64.deb"
  file {"${libgraphite2_3_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libgraphite2_3_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libgraphite2_3_file_name}"
  }
  package { "libgraphite2-3":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libgraphite2_3_file_name}",
    require  => [File["${libgraphite2_3_file_name}"]]
  }

  $libgs9_3_file_name = "libgs9_9.26~dfsg+0-0ubuntu0.16.04.11_amd64.deb"
  file {"${libgs9_3_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libgs9_3_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libgs9_3_file_name}"
  }
  package { "libgs9":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libgs9_3_file_name}",
    require  => [
      File["${libgs9_3_file_name}"],
      Package["libcups2"],
      Package["libgs9-common"],
      Package["libcupsimage2"],
      Package["libijs-0.35"],
      Package["libjbig2dec0"],
      Package["poppler-data"],
    ]
  }

  $poppler_data_file_name = "poppler-data_0.4.7-7_all.deb"
  file {"${poppler_data_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${poppler_data_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${poppler_data_file_name}"
  }
  package { "poppler-data":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${poppler_data_file_name}",
    require  => [
      File["${poppler_data_file_name}"],
    ]
  }

  $libjbig2dec0_file_name = "libjbig2dec0_0.12+20150918-1ubuntu0.1_amd64.deb"
  file {"${libjbig2dec0_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libjbig2dec0_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libjbig2dec0_file_name}"
  }
  package { "libjbig2dec0":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libjbig2dec0_file_name}",
    require  => [
      File["${libjbig2dec0_file_name}"],
    ]
  }

  $libijs_0_35_file_name = "libijs-0.35_0.35-12_amd64.deb"
  file {"${libijs_0_35_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libijs_0_35_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libijs_0_35_file_name}"
  }
  package { "libijs-0.35":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libijs_0_35_file_name}",
    require  => [
      File["${libijs_0_35_file_name}"],
    ]
  }

  $libcupsimage2_file_name = "libcupsimage2_2.1.3-4ubuntu0.10_amd64.deb"
  file {"${libcupsimage2_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libcupsimage2_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libcupsimage2_file_name}"
  }
  package { "libcupsimage2":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libcupsimage2_file_name}",
    require  => [
      File["${libcupsimage2_file_name}"],
      Package["libcupsfilters1"],
    ]
  }

  $libcupsfilters12_file_name = "libcupsfilters1_1.8.3-2ubuntu3.5_amd64.deb"
  file {"${libcupsfilters12_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libcupsfilters12_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libcupsfilters12_file_name}"
  }
  package { "libcupsfilters1":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libcupsfilters12_file_name}",
    require  => [
      File["${libcupsfilters12_file_name}"],
    ]
  }

  $libgs9_common_file_name = "libgs9-common_9.26~dfsg+0-0ubuntu0.16.04.11_all.deb"
  file {"${libgs9_common_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libgs9_common_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libgs9_common_file_name}"
  }
  package { "libgs9-common":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libgs9_common_file_name}",
    require  => [
      File["${libgs9_common_file_name}"],
    ]
  }

  $libcups2_file_name = "libcups2_2.1.3-4ubuntu0.10_amd64.deb"
  file {"${libcups2_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libcups2_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libcups2_file_name}"
  }
  package { "libcups2":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libcups2_file_name}",
    require  => [
      File["${libcups2_file_name}"],
      Package["libavahi-client3"],
      Package["libavahi-common3"],
    ]
  }

  $libavahi_client3_file_name = "libavahi-client3_0.6.32~rc+dfsg-1ubuntu2.3_amd64.deb"
  file {"${libavahi_client3_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libavahi_client3_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libavahi_client3_file_name}"
  }
  package { "libavahi-client3":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libavahi_client3_file_name}",
    require  => [
      File["${libavahi_client3_file_name}"],
      Package["libavahi-common3"],
    ]
  }

  $libavahi_common3_file_name = "libavahi-common3_0.6.32~rc+dfsg-1ubuntu2.3_amd64.deb"
  file {"${libavahi_common3_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libavahi_common3_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libavahi_common3_file_name}"
  }
  package { "libavahi-common3":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libavahi_common3_file_name}",
    require  => [
      File["${libavahi_common3_file_name}"],
      Package["libavahi-common-data"],
    ]
  }

  $libavahi_common_data_file_name = "libavahi-common-data_0.6.32~rc+dfsg-1ubuntu2.3_amd64.deb"
  file {"${libavahi_common_data_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libavahi_common_data_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libavahi_common_data_file_name}"
  }
  package { "libavahi-common-data":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libavahi_common_data_file_name}",
    require  => [File["${libavahi_common_data_file_name}"]]
  }

  $libharfbuzz_icu0_file_name = "libharfbuzz-icu0_1.0.1-1ubuntu0.1_amd64.deb"
  file {"${libharfbuzz_icu0_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libharfbuzz_icu0_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libharfbuzz_icu0_file_name}"
  }
  package { "libharfbuzz-icu0":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libharfbuzz_icu0_file_name}",
    require  => [
      File["${libharfbuzz_icu0_file_name}"],
      Package["libharfbuzz0b"],
    ]
  }

  $libharfbuzz0b_file_name = "libharfbuzz0b_1.0.1-1ubuntu0.1_amd64.deb"
  file {"${libharfbuzz0b_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libharfbuzz0b_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libharfbuzz0b_file_name}"
  }
  package { "libharfbuzz0b":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libharfbuzz0b_file_name}",
    require  => [File["${libharfbuzz0b_file_name}"]]
  }

  $libpotrace0_file_name = "libpotrace0_1.13-2_amd64.deb"
  file {"${libpotrace0_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libpotrace0_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libpotrace0_file_name}"
  }
  package { "libpotrace0":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libpotrace0_file_name}",
    require  => [File["${libpotrace0_file_name}"]]
  }

  $libxaw7_file_name = "libxaw7_2%3a1.0.13-1_amd64.deb"
  file {"${libxaw7_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libxaw7_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libxaw7_file_name}"
  }
  package { "libxaw7":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libxaw7_file_name}",
    require  => [
      File["${libxaw7_file_name}"],
      Package["libxt6"],
      Package["libxmu6"],
    ]
  }

  $libxi6_file_name = "libxi6_2%3a1.7.6-1_amd64.deb"
  file {"${libxi6_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libxi6_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libxi6_file_name}"
  }
  package { "libxi6":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libxi6_file_name}",
    require  => [File["${libxi6_file_name}"]]
  }

  $libxpm4_file_name = "libxpm4_1%3a3.5.11-1ubuntu0.16.04.1_amd64.deb"
  file {"${libxpm4_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libxpm4_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libxpm4_file_name}"
  }
  package { "libxpm4":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libxpm4_file_name}",
    require  => [File["${libxpm4_file_name}"]]
  }

  $libpoppler58_file_name = "libpoppler58_0.41.0-0ubuntu1.14_amd64.deb"
  file {"${libpoppler58_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libpoppler58_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libpoppler58_file_name}"
  }
  package { "libpoppler58":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libpoppler58_file_name}",
    require  => [
      File["${libpoppler58_file_name}"],
      Package["libjpeg8"],
      Package["liblcms2-2"],
      Package["libtiff5"],
    ]
  }

  $liblcms2_2_file_name = "liblcms2-2_2.6-3ubuntu2.1_amd64.deb"
  file {"${liblcms2_2_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${liblcms2_2_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${liblcms2_2_file_name}"
  }
  package { "liblcms2-2":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${liblcms2_2_file_name}",
    require  => [File["${liblcms2_2_file_name}"]]
  }

  $libtiff5_file_name = "libtiff5_4.0.6-1ubuntu0.6_amd64.deb"
  file {"${libtiff5_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libtiff5_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libtiff5_file_name}"
  }
  package { "libtiff5":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libtiff5_file_name}",
    require  => [
      File["${libtiff5_file_name}"],
      Package["libjpeg8"],
      Package["libjbig0"],
    ]
  }


  $libjbig0_file_name = "libjbig0_2.1-3.1_amd64.deb"
  file {"${libjbig0_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libjbig0_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libjbig0_file_name}"
  }
  package { "libjbig0":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libjbig0_file_name}",
    require  => [
      File["${libjbig0_file_name}"],
    ]
  }

  $libjpeg8_file_name = "libjpeg8_8c-2ubuntu8_amd64.deb"
  file {"${libjpeg8_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libjpeg8_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libjpeg8_file_name}"
  }
  package { "libjpeg8":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libjpeg8_file_name}",
    require  => [
      File["${libjpeg8_file_name}"],
      Package["libjpeg-turbo8"],
    ]
  }

  $libjpeg_turbo8_file_name = "libjpeg-turbo8_1.4.2-0ubuntu3.1_amd64.deb"
  file {"${libjpeg_turbo8_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libjpeg_turbo8_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libjpeg_turbo8_file_name}"
  }
  package { "libjpeg-turbo8":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libjpeg_turbo8_file_name}",
    require  => [
      File["${libjpeg_turbo8_file_name}"],
    ]
  }

  $libxmu6_file_name = "libxmu6_2%3a1.1.2-2_amd64.deb"
  file {"${libxmu6_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libxmu6_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libxmu6_file_name}"
  }
  package { "libxmu6":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libxmu6_file_name}",
    require  => [
      File["${libxmu6_file_name}"],
      Package["libxt6"],
      ]
  }

  $libxt6_file_name = "libxt6_1%3a1.1.5-0ubuntu1_amd64.deb"
  file {"${libxt6_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libxt6_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libxt6_file_name}"
  }
  package { "libxt6":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libxt6_file_name}",
    require  => [
      File["${libxt6_file_name}"],
      Package["libsm6"],
      Package["libice6"],
    ]
  }

  $libsm6_file_name = "libsm6_2%3a1.2.2-1_amd64.deb"
  file {"${libsm6_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libsm6_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libsm6_file_name}"
  }
  package { "libsm6":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libsm6_file_name}",
    require  => [
      File["${libsm6_file_name}"],
      Package["libice6"],
    ]
  }

  $libice6_file_name = "libice6_2%3a1.0.9-1_amd64.deb"
  file {"${libice6_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${libice6_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libice6_file_name}"
  }
  package { "libice6":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libice6_file_name}",
    require  => [
      File["${libice6_file_name}"],
      Package["x11-common"]
    ]
  }

  $x11_common_file_name = "x11-common_1%3a7.7+13ubuntu3.1_all.deb"
  file {"${x11_common_file_name}":
    ensure  => present,
    path    => "${local_install_dir}${x11_common_file_name}",
    source  => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${x11_common_file_name}"
  }
  package { "x11-common":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${x11_common_file_name}",
    require  => [
      File["${x11_common_file_name}"],
    ]
  }
}