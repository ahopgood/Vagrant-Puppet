define jenkins::global::java_jdk(
  $major_version = undef,
  $update_version = undef,
  $appendNewJdk = false,
) {

  $jdk_name = "1.${major_version}.0_${update_version}"
  if (versioncmp("${operatingsystem}", "Ubuntu")) {
    $jdk_location = "/usr/lib/jvm/jdk-${major_version}-oracle-x64/"
  } else {
    fail("Operating System [${operatingsystem}] is not supported for setting a Java Jdk")
  }
  if ($appendNewJdk == true) {
    $changes = [
      "clear jdks",
      "set jdks/jdk[last()+1]/name/#text ${jdk_name}",
      "set jdks/jdk[last()]/home/#text  ${jdk_location}",
      "set jdks/jdk[last()]/properties #empty",
    ]
  } else {
    $changes = [
      "clear jdks",
      "rm jdks",
      "set jdks/jdk/name/#text ${jdk_name}",
      "set jdks/jdk/home/#text  ${jdk_location}",
      "set jdks/jdk/properties #empty",
    ]
  }

  augeas { "jenkins_general_config_java_${major_version}_${update_version}":
    show_diff => true,
    incl      => '/var/lib/jenkins/config.xml',
    lens      => 'Xml.lns',
    context   => '/files/var/lib/jenkins/config.xml/hudson/',
    changes   => $changes,
    # require => [] #restart of jenkins service?
  }
  ->
  augeas::formatXML { "format /var/lib/jenkins/config.xml java ${jdk_name}":
    filepath => "/var/lib/jenkins/config.xml"
  }
}

define jenkins::global::maven(
  $major_version = undef,
  $minor_version = undef,
  $patch_version = undef,
){
  $maven_name = "Maven-${major_version}-${minor_version}-${patch_version}"
  if (versioncmp("${operatingsystem}", "Ubuntu")){
    $maven_location = "/usr/share/maven${major_version}/"
  } else {
    fail("Operating System [${operatingsystem}] is not supported for setting maven tooling")
  }
  $puppet_file_dir        = "modules/jenkins/"
  $maven_config_file_name = "hudson.tasks.Maven.xml"
  $maven_config_file      = "/var/lib/jenkins/${maven_config_file_name}"

  file{"${maven_config_file_name}":
    source => "puppet:///${puppet_file_dir}${maven_config_file_name}",
    path => "${maven_config_file}",
    mode => "777",
    owner => "jenkins",
    group => "jenkins",
  }
  ->
  augeas { 'jenkins_general_config_maven':
    show_diff => true,
    incl      => "${maven_config_file}",
    lens      => 'Xml.lns',
    context   => "/files${maven_config_file}",
    changes   => [
      "set hudson.tasks.Maven_-DescriptorImpl/installations/hudson.tasks.Maven_-MavenInstallation/name/#text ${maven_name}",
      "set hudson.tasks.Maven_-DescriptorImpl/installations/hudson.tasks.Maven_-MavenInstallation/home/#text ${maven_location}",
      "set hudson.tasks.Maven_-DescriptorImpl/installations/hudson.tasks.Maven_-MavenInstallation/properties #empty",
    ],
  }
  ->
  augeas::formatXML{"${maven_config_file}":
    filepath => "${maven_config_file}"
  }
}

define jenkins::global::labels(
  $labels = undef ){

  if ($labels == undef){
    fail("A label string is required in order to set a label in Jenkins")
  }

  $changes = [
    "clear label",
    "rm label",
    "set label/#text '${labels}'",
  ]

  augeas { "jenkins_general_config_label_${labels}":
    show_diff => true,
    incl      => '/var/lib/jenkins/config.xml',
    lens      => 'Xml.lns',
    context   => '/files/var/lib/jenkins/config.xml/hudson/',
    changes   => $changes,
  }
  ->
  augeas::formatXML { "format /var/lib/jenkins/config.xml label ${labels}":
    filepath => "/var/lib/jenkins/config.xml"
  }
}