class java::oracle::home {
  $jvm_home_directory = "/usr/lib/jvm/"

  @file { "${jvm_home_directory}":
    ensure => directory,
    path => "${jvm_home_directory}",
  }

  @file  {"/usr/local/share/man/man1":
    path => "/usr/local/share/man/man1",
    ensure => directory,
  }
}