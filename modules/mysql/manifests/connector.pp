/*
* Definition to provide a MySQL connector in Java, also known as j/connector.
* Defaults to version 5.1.40
*/
define mysql::connector::java (
  $major_version = "5",
  $minor_version = "1",
  $patch_version = "40",
  $destination_path = undef,
){

  if ($destination_path == undef){
    fail("A destination_path parameter is required.")
  }
  $puppet_file_dir = "modules/${module_name}/"
  $java_connector = "mysql-connector-java-${major_version}.${minor_version}.${patch_version}"
  $java_connector_archive = "${java_connector}.tar.gz"
  $java_connector_jar = "${java_connector}-bin.jar"

  file {"j-connector-archive ${destination_path}":
    ensure => present,
    source => ["puppet:///${puppet_file_dir}${java_connector_archive}"],
    path => "${destination_path}${java_connector_archive}",
    #    require => File["${local_install_dir}"]
  }

  exec {"Unpack j-connector archive for ${destination_path}":
    path      =>  "/bin/",
    cwd       =>  "${destination_path}",
    command   =>  "/bin/tar xfvz ${destination_path}${java_connector_archive}",
    require   =>  File[ "j-connector-archive ${destination_path}" ],
  }

  file { "${destination_path}${java_connector_jar}":
    ensure => present,
    source => "${destination_path}${java_connector}/${java_connector_jar}",
    path => "${destination_path}${java_connector_jar}",
    require => Exec["Unpack j-connector archive for ${destination_path}"],
  }

  file {"remove unpacked j-connector archive directory ${destination_path}":
    ensure => absent,
    force => true,
    path => "${destination_path}${java_connector}",
    require => [Exec["Unpack j-connector archive for ${destination_path}"],
      File["j-connector-archive ${destination_path}"],
      File[ "${destination_path}${java_connector_jar}"],
    ]
  }

  exec {"remove j-connector archive directory ${destination_path}":
    path => "/bin/",
    command => "rm ${destination_path}${java_connector_archive}",
    require => [File["remove unpacked j-connector archive directory ${destination_path}"],
    ]
  }
}