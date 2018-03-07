class augeas {
  $puppet_file_dir      = "modules/augeas/"
  $file_location        = "${operatingsystem}/${operatingsystemmajrelease}/"
  $local_install_path = "/etc/puppet/"
  $local_install_dir = "${local_install_path}installers/"

  if (versioncmp("${operatingsystem}", "CentOS") == 0 ){
    $provider = "rpm"
    $augeas = "augeas"
    $augeas_libs = "augeas-libs"
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
    $ensure = "${major_version}.${minor_version}.${patch_version}${package}"
  } elsif (versioncmp("${operatingsystem}", "Ubuntu") == 0){
    $major_version = "1"
    $minor_version = "3"
    $patch_version = "0"

    $package = "-0ubuntu1"
    $platform = "${package}_${architecture}.deb"
    $provider = "dpkg"

    $augeas = "augeas-tools"
    $augeas_file = "${augeas}_${major_version}.${minor_version}.${patch_version}${platform}"

    $augeas_libs="libaugeas0"
    $augeas_libs_file="${augeas_libs}_${major_version}.${minor_version}.${patch_version}${platform}"

    $augeas_lenses="augeas-lenses"
    $augeas_lenses_file = "${augeas_lenses}_${major_version}.${minor_version}.${patch_version}${package}_all.deb"

    $ensure = "present"

    file {"${augeas_lenses_file}":
      ensure => present,
      path => "${local_install_dir}${augeas_lenses_file}",
      source => ["puppet:///${puppet_file_dir}${file_location}${augeas_lenses_file}"],
    }
    package{"${augeas_lenses}":
      provider => "${provider}",
      ensure => "${ensure}",
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
  }
  package{"${augeas_libs}":
    provider => "${provider}",
    ensure => "${ensure}",
    source => "${local_install_dir}${augeas_libs_file}",
    require => [File["${augeas_libs_file}"]],
    before => Package["${augeas}"]
  }

  file {"${augeas_file}":
    ensure => present,
    path => "${local_install_dir}${augeas_file}",
    source => ["puppet:///${puppet_file_dir}${file_location}${augeas_file}"],
  }
  package{"${augeas}":
    provider => "${provider}",
    ensure => "${ensure}",
    source => "${local_install_dir}${augeas_file}",
    require => [File["${augeas_file}"]],
  }
}

class augeas::xmlstarlet{
  $major_version = "1"
  $minor_version = "6"
  $patch_version = "1"
  $xmlstarlet = "xmlstarlet"
  $puppet_file_dir = "modules/augeas/"
  $file_location = "${operatingsystem}/${operatingsystemmajrelease}/"

  if (versioncmp("${operatingsystem}", "Ubuntu") == 0){
    if (versioncmp("${operatingsystemmajrelease}", "15.10") == 0){
      $xmlstarlet_file = "${xmlstarlet}_${major_version}.${minor_version}.${patch_version}-1_amd64.deb"
      $provider = "dpkg"
      $ensure = "present"
    } else {
      fail("${operatingsystem} ${operatingsystemmajrelease} not supported")
    }
  } else {
    fail("${operatingsystem} ${operatingsystemmajrelease} not supported")
  }
  file {"${xmlstarlet_file}":
    ensure => present,
    path => "${local_install_dir}${xmlstarlet_file}",
    source => ["puppet:///${puppet_file_dir}${file_location}${xmlstarlet_file}"],
    require => [File["${local_install_dir}"]],
  }
  package{"${xmlstarlet}":
    provider => "${provider}",
    ensure => "${ensure}",
    source => "${local_install_dir}${xmlstarlet_file}",
    require => [File["${xmlstarlet_file}"]],
  }
}

define augeas::formatXML(
  $filepath = undef
){
  exec {"format ${name}":
    path => ["/usr/bin/","/bin/"],
    command => "xmlstarlet format --indent-tab ${filepath} > ${filepath}.tmp && mv ${filepath}.tmp ${filepath}",
    require => Class["augeas::xmlstarlet"]
  }
}

class augeas::yaml_lens {
  augeas::load_lens { "yaml.aug": }
}

define augeas::load_lens(
  $lens_name = "${name}",
  $custom_augeas_lens_location = undef,
) {

  if (versioncmp("${operatingsystem}", "Ubuntu") == 0 and $custom_augeas_lens_location == undef){
    $augeas_lens_location = "/usr/share/augeas/lenses/dist/"
  } elsif ($custom_augeas_lens_location != undef){
    $augeas_lens_location = $custom_augeas_lens_location
  } else {
    fail("${operatingsystem} ${operatingsystemmajrelease} not supported")
  }

  file{"${lens_name}":
    ensure => present,
    mode => "0644",
    owner => "root",
    group => "root",
    path => "${augeas_lens_location}${lens_name}",
    source => "puppet:///${augeas::puppet_file_dir}lens/${lens_name}",
  }
}