class java::openjdk::ubuntu{

}

define java::openjdk::ubuntu::set_default(
  $major_version = undef,
  $from_create = false,
) {

  # If update-java-alternatives -l | grep default is present then
  # do update-java-alternatives -s default
  exec {"Set default for OpenJdk within version ${major_version} from create ${from_create}":
    command => "update-java-alternatives -s default",
    onlyif => "/usr/sbin/update-java-alternatives -l default",
    user => "root",
    path => ["/usr/sbin/","/usr/bin/"],
    require => Package["java-common"],
  }
}

define java::openjdk::ubuntu::create_default(
  $major_version = undef
) {
  $default_jdk = "adoptopenjdk-${major_version}-hotspot-amd64"
  file {"Setting default jinfo for OpenJdk ${major_version}":
    ensure => link,
    path => "/usr/lib/jvm/.default.jinfo",
    target => ".${default_jdk}.jinfo"
  }
  ->
  file {"Setting default JDK directory for OpenJdk ${major_version}":
    ensure => link,
    path => "/usr/lib/jvm/default",
    target => "${default_jdk}",
  }
}