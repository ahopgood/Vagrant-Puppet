class java::oracle::home {
  $jvm_home_directory = "/usr/lib/jvm/"

  @file { "${jvm_home_directory}":
    ensure => directory,
    path => "${jvm_home_directory}",
  }

  $manual_path = "/usr/local/share/man/man1"
  @file  {"${manual_path}":
    path => "${manual_path}",
    ensure => directory,
  }
}