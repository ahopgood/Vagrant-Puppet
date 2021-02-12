define maven::repository($user = undef) {
  file{"${user} repository directory":
    ensure => directory,
    owner => "${user}",
    group => "${user}",
    path => "/home/${user}/.m2/"
  }
}

define maven::repository::settings(
  $user = undef,
  $password = undef,
  $repository_name = undef,
  $repository_address = undef) {
  file {"settings.xml":
    ensure => present,
    owner => "${user}",
    group => "${user}",
    content => template("${module_name}/settings.xml.erb"),
    path => "/home/${user}/.m2/settings.xml",
    require => File["${user} repository directory"]
  }
}

define maven::repository::settings::security(
  $user = undef,
  $master_password = undef) {
  file {"settings-security.xml":
    ensure => present,
    owner => "${user}",
    group => "${user}",
    content => template("${module_name}/settings-security.xml.erb"),
    path => "/home/${user}/.m2/settings-security.xml",
    require => File["${user} repository directory"]
  }
}