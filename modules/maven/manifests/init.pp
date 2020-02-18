class maven(
  $major_version = undef,
  $minor_version = undef,
  $patch_version = undef,
  $java_home = undef,
){


  if (versioncmp("${operatingsystem}", "Ubuntu") == 0){
    notify{"Installing onto ${operatingsystem} ${operatingsystemmajrelease}":}
    if (versioncmp("${major_version}", "3") == 0){
      notify{"Using maven version ${major_version}.${minor_version}.${patch_version} ${operatingsystemrelease}": }
    } else {
      fail("Maven version ${major_version} not supported")
    }
  } else {
    fail("${operatingsystem} is currently not supported for installing Maven ${major_version}")
  }

  $maven_binary_name="apache-maven-${major_version}.${minor_version}.${patch_version}-bin.tar.gz"

  $local_install_path = "/etc/puppet/"
  $local_install_dir = "${local_install_path}installers/"
  $puppet_file_dir    = "modules/${name}/"

  $maven_home = "/usr/share/maven${major_version}/"
  $alternatives_priority = "${major_version}${minor_version}${patch_version}"

  $slave = {
    "mvnDebug" => "${maven_home}bin/",
  }

  file {"maven-installer":
    ensure => present,
    path => "${local_install_dir}${maven_binary_name}",
    source => "puppet:///${puppet_file_dir}${maven_binary_name}"
  }
  ->
  file {"maven-install-dir":
    ensure => directory,
    path => "${maven_home}",
  }
  ->
  exec {"unpack maven ${major_version}":
    # cwd => "${maven_home}",
    path => "/bin/",
    command => "tar -xvzf ${local_install_dir}${maven_binary_name} -C ${maven_home} --strip-components=1",
  }
  ->
  alternatives::install {
    "alternatives-install-mvn":
      executableName => "mvn",
      executableLocation => "${maven_home}bin/",
      priority => "${alternatives_priority}",
      slaveBinariesHash => $slave,
  }
  ->
  file {"create-etc-maven":
    ensure => directory,
    path => "/etc/maven${major_version}",
  }
  ->
  exec {"move-config-to-etc":
    path => "/bin/",
    command => "mv ${maven_home}conf/* /etc/maven${major_version}/",
    # unless => "/bin/ls /etc/maven3/"
  }
  ->
  exec {"delete-conf-dir":
    path => "/bin/",
    command => "rm -rf ${maven_home}conf/",
    onlyif => "/bin/ls ${maven_home}conf/"
  }
  ->
  file {"set-maven-config-symlink":
    ensure => link,
    path => "${maven_home}conf/",
    target => "/etc/maven${major_version}/",
  }
  ->
  exec{"move-m2.conf-to-etc":
    path => "/bin/",
    command => "mv ${maven_home}bin/m2.conf /etc/maven${major_version}/"
  }
  ->
  file {"set-m2.conf-symlink":
    ensure => link,
    path => "${maven_home}bin/m2.conf",
    target => "${maven_home}conf/m2.conf",
  }

  #sudo tar -xvzf apache-maven-3.3.9-bin.tar.gz
  #mv apache-maven-3.3.9

  # Manual install:
  #/usr/lib/mvn/apache-maven3.3.9
  #M2_HOME, M2, MAVEN_OPTS

  #export M2_HOME=/opt/maven
  #export PATH=${M2_HOME}/bin:${PATH}

  #sudo nano /etc/profile.d/mavenenv.sh

  # Installation of maven via Ubuntu
  # apt-get install maven2
  # Puts the contents of maven tar.gz into
  # /usr/share/maven
  # ls -l /usr/share/maven
  # bin
  # boot
  # conf -> /etc/maven
  # lib
  # man
  # ls -l /etc/maven
  # m2.conf
  # settings.xml

  # Java style installation, using alternatives and default directories
  # /usr/bin/java -> /etc/alternativies/java -> /usr/lib/jvm/jdk-8-oracle-x64/jre/bin/java
  # /usr/bin/mvn -> /etc/alternatives/mvn -> /usr/lib/mvn/apache-maven-3.0.5/bin/mvn
}