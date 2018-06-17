class jenkins::cli {
  @file {"jenkins-cli.jar":
    ensure => present,
    source => "/var/cache/jenkins/war/WEB-INF/jenkins-cli.jar",
    path => "/usr/bin/jenkins-cli.jar",
    # owner => "root",
    # group => "root",
    mode => "777",
  }
}