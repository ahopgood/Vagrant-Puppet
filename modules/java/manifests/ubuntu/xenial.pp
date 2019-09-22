define java::ubuntu::xenial(
  $java_package = undef,
  $major_version = undef,
  $update_version = unde
) {
  $local_install_path = "/etc/puppet/"
  $local_install_dir = "${local_install_path}installers/"
  $puppet_file_dir = "modules/java/"
  $platform = "amd64"

 if ((versioncmp("${major_version}", "8") == 0)
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