class augeas {
  $puppet_file_dir      = "modules/augeas/"
  $file_location        = "${operatingsystem}/${operatingsystemmajrelease}/"

  if (versioncmp("${operatingsystem}", "CentOS") == 0 ){
    $provider = "rpm"
    $augeas = "augeas"
    $augeas_libs="augeas-libs"
    if (versioncmp("${operatingsystemmajrelease}", "7") == 0){
      $major_version = "1"
      $minor_version = "4"
      $patch_version = "0"

      $package = "-2.el7"
      $platform = "${package}.${architecture}.rpm"

      $augeas_file = "${augeas}-${major_version}.${minor_version}.${patch_version}${platform}"
      $augeas_libs_file = "${augeas_libs}-${major_version}.${minor_version}.${patch_version}${platform}"

    } elsif (versioncmp("${operatingsystemmajrelease}", "6") == 0) {
      $major_version = "1"
      $minor_version = "0"
      $patch_version = "0"

      $package = "-10.el6"
      $platform = "${package}.${architecture}.rpm"

      $augeas_file = "${augeas}-${major_version}.${minor_version}.${patch_version}${platform}"
      $augeas_libs_file = "${augeas_libs}-${major_version}.${minor_version}.${patch_version}${platform}"
    } else {
      fail ("${operatingsystem} ${operatingsystemmajrelease} is currently not supported for the augeas module")
    }
  } elsif (versioncmp("${operatingsystem}", "Ubuntu") == 0){
    $major_version = "1"
    $minor_version = "3"
    $patch_version = "0"

    $package = "-0ubuntu1_"
    $platform = "${package}${architecture}.deb"
    $provider = "dpkg"

    $augeas = "augeas-tools"
    $augeas_file = "${augeas}_${major_version}.${minor_version}.${patch_version}${platform}"

    $augeas_libs="libaugeas0"
    $augeas_libs_file="${augeas_libs}_${major_version}.${minor_version}.${patch_version}${platform}"

    $augeas_lenses="augeas-lenses"
    $augeas_lenses_file = "${augeas_lenses}_${major_version}.${minor_version}.${patch_version}${package}all.deb"

    file {"${augeas_lenses_file}":
      ensure => present,
      path => "${local_install_dir}${augeas_lenses_file}",
      source => ["puppet:///${puppet_file_dir}${file_location}${augeas_lenses_file}"],
      require => [File["${local_install_dir}"]],
    }
    package{"${augeas_lenses}":
      provider => "${provider}",
#      ensure => "${major_version}.${minor_version}.${patch_version}${package}",
      source => "${local_install_dir}${augeas_lenses_file}",
      require => [File["${augeas_lenses_file}"]],
      before => Package["${augeas_libs}"]
    }

  } else {
    fail("${operatingsystem} is currently not supported for the augeas module")
  }
  file {"${augeas_libs_file}":
    ensure => present,
    path => "${local_install_dir}${augeas_libs_file}",
    source => ["puppet:///${puppet_file_dir}${file_location}${augeas_libs_file}"],
    require => [File["${local_install_dir}"]],
  }
  package{"${augeas_libs}":
    provider => "${provider}",
#    ensure => "${major_version}.${minor_version}.${patch_version}${package}",
    source => "${local_install_dir}${augeas_libs_file}",
    require => [File["${augeas_libs_file}"]],
    before => Package["${augeas}"]
  }

  file {"${augeas_file}":
    ensure => present,
    path => "${local_install_dir}${augeas_file}",
    source => ["puppet:///${puppet_file_dir}${file_location}${augeas_file}"],
    require => [File["${local_install_dir}"]],
  }
  package{"${augeas}":
    provider => "${provider}",
#    ensure => "${major_version}.${minor_version}.${patch_version}${package}",
    source => "${local_install_dir}${augeas_file}",
    require => [File["${augeas_file}"]],
  }
}
