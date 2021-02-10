class jenkins::cli {
  if (versioncmp("${jenkins::major_version}.${jenkins::minor_version}.${jenkins::patch_version}", "2.263.3") < 0){
    $source = "/var/cache/jenkins/war/WEB-INF/jenkins-cli.jar"
    # $source = "http://localhost:8080/jnlpJars/jenkins-cli.jar"
  } else {
    $source = "/var/cache/jenkins/war/WEB-INF/lib/cli-${jenkins::major_version}.${jenkins::minor_version}.${jenkins::patch_version}.jar"
  }
  @file {"jenkins-cli.jar":
    ensure => present,
    source => $source,
    path => "/usr/bin/jenkins-cli.jar",
    # owner => "root",
    # group => "root",
    mode => "777",
    require => [
      Package["jenkins"],
      Exec["wait"]
    ]
  }
}