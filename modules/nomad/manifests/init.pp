class nomad (
  $major_version = "1",
  $minor_version = "2",
  $patch_version = "6"
) {
  $local_install_path = "/etc/puppet/"
  $local_install_dir  = "${local_install_path}installers/"
  $puppet_file_dir    = "modules/nomad/"

  $nomad_file_name = "nomad_${major_version}.${minor_version}.${patch_version}_${architecture}.deb"

  $nomad_package_name = "nomad"
  file { "${nomad_file_name}":
    ensure => present,
    path   => "${local_install_dir}${nomad_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${nomad_file_name}",
  }
  package { "${nomad_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${nomad_file_name}",
    require  => [
      File["${nomad_file_name}"],
    ]
  }
}

define nomad::levant (
  $major_version = "0",
  $minor_version = "3",
  $patch_version = "1"
)
  {
    $local_install_path = "/etc/puppet/"
    $local_install_dir  = "${local_install_path}installers/"
    $puppet_file_dir    = "modules/nomad/"

    $levant_file_name = "levant_${major_version}.${minor_version}.${patch_version}_linux_${architecture}.zip"

    file { "${levant_file_name}":
      ensure => present,
      path   => "${local_install_dir}${levant_file_name}",
      source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${levant_file_name}",
    }

    exec {"unzip ${levant_file_name}":
      cwd => "${local_install_dir}",
      path => "/usr/bin/",
      command => "unzip -o ${local_install_dir}${levant_file_name} -d /usr/bin",
      unless => "levant -version | /bin/grep v${major_version}.${minor_version}.${patch_version}",
      require => [
        File["${levant_file_name}"]
      ]
    }
}