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
