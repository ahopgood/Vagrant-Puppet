class augeas {
  $puppet_file_dir      = "modules/augeas/"
  $file_location        = "${operatingsystem}/${operatingsystemmajrelease}/"

  if (versioncmp("${operatingsystem}", "CentOS") == 0 ){
    if (versioncmp("${operatingsystemmajrelease}", "7") == 0){
      $major_version = "1"
      $minor_version = "4"
      $patch_version = "0"

      $package = "-2.el7"
      $platform = "${package}.${architecture}.rpm"

    } elsif (versioncmp("${operatingsystemmajrelease}", "6") == 0) {
      $major_version = "1"
      $minor_version = "0"
      $patch_version = "0"

      $package = "-10.el6"
      $platform = "${package}.${architecture}.rpm"
    } else {
      fail ("${operatingsystem} ${operatingsystemmajrelease} is currently not supported for the augeas module")
    }

    $augeas_libs_file = "augeas-libs-${major_version}.${minor_version}.${patch_version}${platform}"

    file {"${augeas_libs_file}":
      ensure => present,
      path => "${local_install_dir}${augeas_libs_file}",
      source => ["puppet:///${puppet_file_dir}${file_location}${augeas_libs_file}"],
      require => [File["${local_install_dir}"]],
    }
    package{"augeas-libs":
      provider => "rpm",
      ensure => "${major_version}.${minor_version}.${patch_version}${package}",
      source => "${local_install_dir}${augeas_libs_file}",
      require => [File["${augeas_libs_file}"]],
    }

    $augeas_file = "augeas-${major_version}.${minor_version}.${patch_version}${platform}"
    file {"${augeas_file}":
      ensure => present,
      path => "${local_install_dir}${augeas_file}",
      source => ["puppet:///${puppet_file_dir}${file_location}${augeas_file}"],
      require => [File["${local_install_dir}"]],
    }
    package{"augeas":
      provider => "rpm",
      ensure => "${major_version}.${minor_version}.${patch_version}${package}",
      source => "${local_install_dir}${augeas_file}",
      require => [File["${augeas_file}"], Package["augeas-libs"]],
    }

  } else {
    fail("${operatingsystem} is currently not supported for the augeas module")
  }
}
