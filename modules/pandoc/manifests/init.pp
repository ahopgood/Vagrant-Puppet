class pandoc{

  $local_install_path = "/etc/puppet/"
  $local_install_dir  = "${local_install_path}installers/"
  $puppet_file_dir    = "modules/pandoc/"

  if (versioncmp("${operatingsystem}", "Ubuntu") == 0){
    $pandoc_major_version = "2"
    $pandoc_minor_version = "1"
    $pandoc_patch_version = "1"
    $package_type = "deb"
    $pandoc_file_name = "pandoc-${pandoc_major_version}.${pandoc_minor_version}.${pandoc_patch_version}-1-${architecture}.${package_type}"
  } else {
    fail("${operatingsystem} is not currently supported")
  }

  notify{"${pandoc_file_name}":}
  file {"${pandoc_file_name}":
    ensure => present,
    path => "${local_install_dir}${pandoc_file_name}",
    source => ["puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${pandoc_file_name}"],
  }

  package {"pandoc":
    ensure => present,
    provider => dpkg,
    source => "${local_install_dir}${pandoc_file_name}",
    require => [Package["texlive-latex-base"]]
  }

  $texlive_latex_base_file_name = "texlive-latex-base_2013.20140215-1ubuntu0.1_all.${package_type}"
  file{"${texlive_latex_base_file_name}":
    ensure => present,
    path => "${local_install_dir}${texlive_latex_base_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${texlive_latex_base_file_name}",
  }
  package{"texlive-latex-base":
    # ensure => '',
    ensure => present,
    provider => dpkg,
    source => "${local_install_dir}${texlive_latex_base_file_name}",
    require => [File["${texlive_latex_base_file_name}"], Package["texlive-binaries"],
      Package["texlive-base"], Package["tex-common"]]
  }

  $texlive_base_file_name = "texlive-base_2013.20140215-1ubuntu0.1_all.${package_type}"
  file{"${texlive_base_file_name}":
    ensure => present,
    path => "${local_install_dir}${texlive_base_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${texlive_base_file_name}",
  }
  package{"texlive-base":
    # ensure => '2013.20140215-1ubuntu0.1',
    ensure => present,
    provider => dpkg,
    source => "${local_install_dir}${texlive_base_file_name}",
    require => [File["${texlive_base_file_name}"], Package["texlive-binaries"],
      Package["xdg-utils"], Package["luatex"],
      Package["libpaper-utils"]]
  }

  $xdg_utils_file_name = "xdg-utils_1.1.0~rc1-2ubuntu7.1_all.${package_type}"
  file{"${xdg_utils_file_name}":
    ensure => present,
    path => "${local_install_dir}${xdg_utils_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${xdg_utils_file_name}",
  }
  package{"xdg-utils":
    # ensure => "1.1.0~rc1-2ubuntu7.1",
    ensure => present,
    provider => dpkg,
    source => "${local_install_dir}${xdg_utils_file_name}",
    require => [File["${xdg_utils_file_name}"]]
  }

  $libpaper_utils_file_name = "libpaper-utils_1.1.24+nmu2ubuntu3_${architecture}.${package_type}"
  file{"${libpaper_utils_file_name}":
    ensure => present,
    path => "${local_install_dir}${libpaper_utils_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libpaper_utils_file_name}",
  }
  package{"libpaper-utils":
    # ensure => "1.1.0~rc1-2ubuntu7.1",
    ensure => present,
    provider => dpkg,
    source => "${local_install_dir}${libpaper_utils_file_name}",
    require => [File["${libpaper_utils_file_name}"], Package["libpaper1"]]
  }

  $luatex_file_name = "luatex_0.76.0-3ubuntu1_${architecture}.${package_type}"
  file{"${luatex_file_name}":
    ensure => present,
    path => "${local_install_dir}${luatex_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${luatex_file_name}",
  }
  package{"luatex":
    # ensure => "0.76.0-3ubuntu1",
    ensure => present,
    provider => dpkg,
    source => "${local_install_dir}${luatex_file_name}",
    require => [File["${luatex_file_name}"]]
  }

  $texlive_binaries_file_name = "texlive-binaries_2013.20130729.30972-2build3_${architecture}.${package_type}"
  file{"${texlive_binaries_file_name}":
    ensure => present,
    path => "${local_install_dir}${texlive_binaries_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${texlive_binaries_file_name}",
  }
  package{"texlive-binaries":
    # ensure => '2013.20130729.30972-2build3',
    ensure => present,
    provider => dpkg,
    source => "${local_install_dir}${texlive_binaries_file_name}",
    require => [File["${texlive_binaries_file_name}"], Package["libgs9"],
      Package["libicu52"], Package["libkpathsea6"],
      Package["libpoppler44"], Package["libptexenc1"],
      Package["tex-common"]]
  }

  $tex_common_file_name = "tex-common_4.04_all.${package_type}"
  file{"${tex_common_file_name}":
    ensure => present,
    path => "${local_install_dir}${tex_common_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${tex_common_file_name}",
  }
  package{"tex-common":
    # ensure => "4.04",
    ensure => present,
    provider => dpkg,
    source => "${local_install_dir}${tex_common_file_name}",
    require => [File["${tex_common_file_name}"]]
  }

  $libptexenc1_file_name = "libptexenc1_2013.20130729.30972-2build3_${architecture}.${package_type}"
  file{"${libptexenc1_file_name}":
    ensure => present,
    path => "${local_install_dir}${libptexenc1_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libptexenc1_file_name}",
  }
  package{"libptexenc1":
    # ensure => "2013.20130729.30972-2build3",
    ensure => present,
    provider => dpkg,
    source => "${local_install_dir}${libptexenc1_file_name}",
    require => [File["${libptexenc1_file_name}"]]
  }

  $libpoppler44_file_name = "libpoppler44_0.24.5-2ubuntu4.9_${architecture}.${package_type}"
  file{"${libpoppler44_file_name}":
    ensure => present,
    path => "${local_install_dir}${libpoppler44_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libpoppler44_file_name}",
  }
  package{"libpoppler44":
    # ensure => "0.24.5-2ubuntu4.9",
    ensure => present,
    provider => dpkg,
    source => "${local_install_dir}${libpoppler44_file_name}",
    require => [File["${libpoppler44_file_name}"]]
  }

  $libkpathsea6_file_name = "libkpathsea6_2013.20130729.30972-2build3_${architecture}.${package_type}"
  file{"${libkpathsea6_file_name}":
    ensure => present,
    path => "${local_install_dir}${libkpathsea6_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libkpathsea6_file_name}",
  }
  package{"libkpathsea6":
    # ensure => "2013.20130729.30972-2build3",
    ensure => present,
    provider => dpkg,
    source => "${local_install_dir}${libkpathsea6_file_name}",
    require => [File["${libkpathsea6_file_name}"]]
  }

  $libicu52_file_name = "libicu52_52.1-3ubuntu0.7_${architecture}.${package_type}"
  file{"${libicu52_file_name}":
    ensure => present,
    path => "${local_install_dir}${libicu52_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libicu52_file_name}",
  }
  package{"libicu52":
    # ensure => '52.1-3ubuntu0.7',
    ensure => present,
    provider => dpkg,
    source => "${local_install_dir}${libicu52_file_name}",
    require => [File["${libicu52_file_name}"]]
  }

  $libgs9_file_name = "libgs9_9.10~dfsg-0ubuntu10.10_${architecture}.${package_type}"
  file {"${libgs9_file_name}":
    ensure => present,
    path => "${local_install_dir}${libgs9_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libgs9_file_name}",
  }
  package{"libgs9":
    # ensure => '9.10~dfsg-0ubuntu10.10',
    ensure => present,
    provider => dpkg,
    source => "${local_install_dir}${libgs9_file_name}",
    require => [File["${libgs9_file_name}"], Package["poppler-data"],
      Package["libgs9-common"], Package["libjbig2dec0"],
      Package["libijs-0.35"], Package["libcupsimage2"],
      Package["libpaper1"]]
  }

  $libpaper1_file_name = "libpaper1_1.1.24+nmu2ubuntu3_${architecture}.${package_type}"
  file{"${libpaper1_file_name}":
    # ensure => "1.1.24+nmu2ubuntu3",
    ensure => present,
    path => "${local_install_dir}${libpaper1_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libpaper1_file_name}",
  }
  package{"libpaper1":
    ensure => present,
    provider => dpkg,
    source => "${local_install_dir}${libpaper1_file_name}",
    require => [File["${libpaper1_file_name}"]]
  }

  $libcupsimage2_file_name = "libcupsimage2_2.1.0-4ubuntu3_${architecture}.${package_type}"
  file{"${libcupsimage2_file_name}":
    # ensure => "2.1.0-4ubuntu3"
    ensure => present,
    path => "${local_install_dir}${libcupsimage2_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libcupsimage2_file_name}",
  }
  package{"libcupsimage2":
    ensure => present,
    provider => dpkg,
    source => "${local_install_dir}${libcupsimage2_file_name}",
    require => [File["${libcupsimage2_file_name}"], Package["libcupsfilters1"]]
  }

  $libcupsfilters1_file_name = "libcupsfilters1_1.0.52-0ubuntu1.7_${architecture}.${package_type}"
  file{"${libcupsfilters1_file_name}":
    ensure => present,
    path => "${local_install_dir}${libcupsfilters1_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libcupsfilters1_file_name}",
  }
  package{"libcupsfilters1":
    # ensure => '1.0.52-0ubuntu1.7',
    ensure => installed,
    provider => dpkg,
    source => "${local_install_dir}${libcupsfilters1_file_name}",
    require => [File["${libcupsfilters1_file_name}"]]
  }

  $libijs_file_name = "libijs-0.35_0.35-8build1_${architecture}.${package_type}"
  file{"${libijs_file_name}":
    ensure => present,
    path => "${local_install_dir}${libijs_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libijs_file_name}",
  }
  package{"libijs-0.35":
    # ensure => '0.35-8build1',
    ensure => installed,
    provider => dpkg,
    source => "${local_install_dir}${libijs_file_name}",
    require => File["${libijs_file_name}"]
  }

  $libjbig2dec0_file_name = "libjbig2dec0_0.11+20120125-1ubuntu1.1_${architecture}.${package_type}"
  file{"${libjbig2dec0_file_name}":
    ensure => present,
    path => "${local_install_dir}${libjbig2dec0_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libjbig2dec0_file_name}",
  }
  package{"libjbig2dec0":
    # ensure => '0.11+20120125-1ubuntu1.1',
    ensure => installed,
    provider => dpkg,
    source => "${local_install_dir}${libjbig2dec0_file_name}",
    require => File["${libjbig2dec0_file_name}"]
  }

  $poppler_data_file_name = "poppler-data_0.4.6-4_all.${package_type}"

  file{"${poppler_data_file_name}":
    ensure => present,
    path => "${local_install_dir}${poppler_data_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${poppler_data_file_name}",
  }
  package{"poppler-data":
    # ensure => '0.4.6-4',
    ensure => installed,
    provider => dpkg,
    source => "${local_install_dir}${poppler_data_file_name}",
    require => File["${poppler_data_file_name}"]
  }

  $libgs9_common_file_name = "libgs9-common_9.10~dfsg-0ubuntu10.10_all.${package_type}"

  file{"${libgs9_common_file_name}":
    ensure => present,
    path => "${local_install_dir}${libgs9_common_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libgs9_common_file_name}",
  }
  package{"libgs9-common":
    # ensure => '9.10~dfsg-0ubuntu10.10',
    ensure => installed,
    provider => dpkg,
    source => "${local_install_dir}${libgs9_common_file_name}",
    require => File["${libgs9_common_file_name}"]
  }
}

# texlive-base
# vagrant@vagrant-ubuntu-wily-64:/var/lib/jenkins/workspace/Markdown-master-pipeline@script/publisher$ sudo dpkg -i /vagrant/files/texlive-base_2013.20140215-1ubuntu0.1_all.deb
# Selecting previously unselected package texlive-base.
# (Reading database ... 88611 files and directories currently installed.)
# Preparing to unpack .../texlive-base_2013.20140215-1ubuntu0.1_all.deb ...
# Unpacking texlive-base (2013.20140215-1ubuntu0.1) ...
#   dpkg: dependency problems prevent configuration of texlive-base:
# texlive-base depends on xdg-utils; however:
# Package xdg-utils is not installed.
#   texlive-base depends on luatex (>= 0.70.1); however:
# Package luatex is not installed.
#   texlive-base depends on texlive-binaries (>= 2013.20130512); however:
# Package texlive-binaries is not configured yet.
# texlive-base depends on libpaper-utils; however:
# Package libpaper-utils is not installed.
#
#   dpkg: error processing package texlive-base (--install):
# dependency problems - leaving unconfigured
# Processing triggers for man-db (2.7.4-1) ...
# Processing triggers for install-info (6.0.0.dfsg.1-3) ...
# Processing triggers for mime-support (3.58ubuntu1) ...
# Errors were encountered while processing:
# texlive-base

#texlive-binaries
# vagrant@vagrant-ubuntu-wily-64:/var/lib/jenkins/workspace/Markdown-master-pipeline@script/publisher$ sudo dpkg -i /vagrant/files/texlive-binaries_2013.20130729.30972-2build3_amd64.deb
# Selecting previously unselected package texlive-binaries.
# (Reading database ... 88385 files and directories currently installed.)
# Preparing to unpack .../texlive-binaries_2013.20130729.30972-2build3_amd64.deb ...
# Unpacking texlive-binaries (2013.20130729.30972-2build3) ...
#   dpkg: dependency problems prevent configuration of texlive-binaries:
# texlive-binaries depends on libgs9 (>= 8.61.dfsg.1); however:
# Package libgs9 is not installed.
#   texlive-binaries depends on libicu52 (>= 52~m1-1~); however:
# Package libicu52 is not installed.
#   texlive-binaries depends on libkpathsea6; however:
# Package libkpathsea6 is not installed.
#   texlive-binaries depends on libpoppler44 (>= 0.24.5); however:
# Package libpoppler44 is not installed.
#   texlive-binaries depends on libptexenc1; however:
# Package libptexenc1 is not installed.
#
#   dpkg: error processing package texlive-binaries (--install):
# dependency problems - leaving unconfigured
# Processing triggers for install-info (6.0.0.dfsg.1-3) ...
# Processing triggers for man-db (2.7.4-1) ...
# Errors were encountered while processing:
# texlive-binaries

define pandoc::texlive-fonts-recommended {

  $texlive_fonts_recommended_file_name = "texlive-fonts-recommended_2013.20140215-1ubuntu0.1_all.${pandoc::package_type}"
  file {"${texlive_fonts_recommended_file_name}":
    ensure => present,
    path => "${local_install_dir}${texlive_fonts_recommended_file_name}",
    source => "puppet:///${pandoc::puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${texlive_fonts_recommended_file_name}",
  }
  package{"texlive-font-recommended":
    ensure => installed,
    provider => dpkg,
    source => "${local_install_dir}${texlive_fonts_recommended_file_name}",
    require => [File["${texlive_fonts_recommended_file_name}"], Package["texlive-base"]]
  }
}

define pandoc::texlive-latex-extra {
  $texlive_latex_extra = "texlive-latex-extra_2013.20140215-2_all.${pandoc::package_type}"
  file {"${texlive_latex_extra}":
    ensure => present,
    path => "${local_install_dir}${texlive_latex_extra}",
    source => "puppet:///${pandoc::puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${texlive_latex_extra}",
  }
  package{"texlive-latex-extra":
    ensure => installed,
    provider => dpkg,
    source => "${local_install_dir}${texlive_latex_extra}",
    require => [File["${texlive_latex_extra}"], Package["texlive-binaries"], Package["texlive-base"]]
  }

  $preview_latex_style = "preview-latex-style_11.87-1ubuntu2_all.${pandoc::package_type}"
  file {"${preview_latex_style}":
    ensure => present,
    path => "${local_install_dir}${preview_latex_style}",
    source => "puppet:///${pandoc::puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${preview_latex_style}",
  }
  package{"preview-latex-style":
    ensure => installed,
    provider => dpkg,
    source => "${local_install_dir}${preview_latex_style}",
    require => [File["${preview_latex_style}"], ]
  }

  $texlive_latex_recommended = "texlive-latex-recommended_2013.20140215-1ubuntu0.1_all.${pandoc::package_type}"
  file {"${texlive_latex_recommended}":
    ensure => present,
    path => "${local_install_dir}${texlive_latex_recommended}",
    source => "puppet:///${pandoc::puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${texlive_latex_recommended}",
  }
  package{"texlive-latex-recommended":
    ensure => installed,
    provider => dpkg,
    source => "${local_install_dir}${texlive_latex_recommended}",
    require => [File["${texlive_latex_recommended}"], Package["texlive-base"], Package["texlive-binaries"]]
  }

  $texlive_pictures_file_name = "texlive-pictures_2013.20140215-1ubuntu0.1_all.${pandoc::package_type}"
  file {"${texlive_pictures_file_name}":
    ensure => present,
    path => "${local_install_dir}${texlive_pictures_file_name}",
    source => "puppet:///${pandoc::puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${texlive_pictures_file_name}",
  }
  package{"texlive-pictures":
    ensure => installed,
    provider => dpkg,
    source => "${local_install_dir}${texlive_pictures_file_name}",
    require => [File["${texlive_pictures_file_name}"], Package["texlive-base"], Package["texlive-binaries"] ]
  }
}