define jenkins::global::java_jdk(
  $major_version = undef,
  $update_version = undef,
  $appendNewJdk = false,
  $adoptOpenJDK = false,
) {

  $jdk_name = "1.${major_version}.0_${update_version}"
  if (versioncmp("${operatingsystem}", "Ubuntu")) {
    if ($adoptOpenJDK) {
      $jdk_location = "/usr/lib/jvm/adoptopenjdk-${major_version}-hotspot-amd64/"
    } else {
      $jdk_location = "/usr/lib/jvm/jdk-${major_version}-oracle-x64/"
    }
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

define jenkins::global::reload::config(
  $username = 'admin',
  $password = hiera('jenkins::admin::password::plaintext','test'),
){

  if (versioncmp("${jenkins::major_version}.${jenkins::minor_version}.${jenkins::patch_version}", "2.107.1") > 0) {
    $command = "java -jar /usr/bin/jenkins-cli.jar -s http://127.0.0.1:8080 -auth ${username}:${password} reload-configuration"
  } else {
    $command = "java -jar /usr/bin/jenkins-cli.jar -s http://127.0.0.1:8080 reload-configuration --username ${username} --password ${password}"
  }

  include jenkins::cli
  realize(File["jenkins-cli.jar"])
  exec{"reload-config [${title}]":
    path => "/usr/bin/",
    # user => "root",
    tries => 10,
    try_sleep => 5,
    command => "${command}",
    require => File["jenkins-cli.jar"]
  }
}

define jenkins::global::env::var(
  $envValuesHash = undef
) {
  include stdlib
  $entriesArray = $envValuesHash.map | $env_name, $env_value | {
    [
      "set globalNodeProperties/hudson.slaves.EnvironmentVariablesNodeProperty/envVars/tree-map/string[last() + 1]/#text \"${env_name}\"",
      "set globalNodeProperties/hudson.slaves.EnvironmentVariablesNodeProperty/envVars/tree-map/string[last() + 1]/#text \"${env_value}\""
    ]
  }

  $length = sprintf("%d",$envValuesHash.size)
  $opener = [
    "rm globalNodeProperties",
    "set globalNodeProperties/hudson.slaves.EnvironmentVariablesNodeProperty/envVars/#attribute/serialization \"custom\"",
    "set globalNodeProperties/hudson.slaves.EnvironmentVariablesNodeProperty/envVars/unserializable-parents #empty",
    "set globalNodeProperties/hudson.slaves.EnvironmentVariablesNodeProperty/envVars/tree-map/default/comparator  #empty",
    "set globalNodeProperties/hudson.slaves.EnvironmentVariablesNodeProperty/envVars/tree-map/default/comparator/#attribute/class \"hudson.util.CaseInsensitiveComparator\"",
    "set globalNodeProperties/hudson.slaves.EnvironmentVariablesNodeProperty/envVars/tree-map/int/#text \"$length\"", # incremented based on the number of values in the map
  ]

  $changes = $opener + flatten($entriesArray)

  augeas { "jenkins_general_config_env_var":
    show_diff => true,
    incl      => '/var/lib/jenkins/config.xml',
    lens      => 'Xml.lns',
    context   => '/files/var/lib/jenkins/config.xml/hudson/',
    changes   => $changes,
    require   => Package["jenkins"]
  }
  ->
  augeas::formatXML { "format /var/lib/jenkins/config.xml env-value":
    filepath => "/var/lib/jenkins/config.xml"
  }
}

define jenkins::global::clouds::nomad(
  $nomadHost = undef,
  $agentImage = 'altairbob/nomad-agent-docker-cli:latest',
  $dockerInDockerImage = 'docker:dind',
  $jenkinsHost = undef,
  $labels = undef,
  $masterExecutors = "2",
  $memory = "256",
  $nomadTaskExecutors = "1",
  $nomadWorkerTimeout = "1"
) {
  $registryPassword = hiera('jenkins::dockerRegistry::credentials::password','default')

  $subContext = "clouds/org.jenkinsci.plugins.nomad.NomadCloud"
  $templateContext = "${subContext}/templates/org.jenkinsci.plugins.nomad.NomadWorkerTemplate"
  # Job with JENKINS_TUNNEL (for reverse proxying see https://hub.docker.com/r/jenkins/inbound-agent/)
  $jobTemplate = "job &quot;%WORKER_NAME%&quot; {\n  region = &quot;global&quot;\n  datacenters = [&quot;dc1&quot;]\n  type = &quot;batch&quot;\n\n  group &quot;jenkins-worker-dind-taskgroup&quot; {\n    network {\n      mode = &quot;bridge&quot;\n    \n      port &quot;tcp&quot; {\n        to     = 2376\n      }\n    }\n    \n    task &quot;jenkins-worker&quot; {\n      driver = &quot;docker&quot;\n\n      env {\n        DOCKER_TLS_CERTDIR = &quot;/certs&quot;\n        JENKINS_URL = &quot;http://${jenkinsHost}:8080&quot;\n        JENKINS_AGENT_NAME = &quot;%WORKER_NAME%&quot;\n        JENKINS_SECRET = &quot;%WORKER_SECRET%&quot;\n        JENKINS_TUNNEL = &quot;${jenkinsHost}:50000&quot;\n        DOCKER_CERT_PATH = &quot;/certs/client&quot;\n        DOCKER_TLS_VERIFY =  &quot;1&quot;\n        JENKINS_JAVA_OPTS=&quot;-XX:MaxRAMPercentage=25.00 -XX:MinRAMPercentage=25.00 -XX:+UseParallelGC -XshowSettings:vm&quot;\n        DOCKER_HOST = &quot;tcp://127.0.0.1:\${NOMAD_PORT_tcp}&quot;\n      }\n\n      config {\n        image = &quot;${agentImage}&quot;\n        volumes = [\n          &quot;/volumes/dind/jenkins-docker-certs:/certs/client:ro&quot;,\n        ]\n        auth {\n            username = &quot;jenkins&quot;\n            password = &quot;${registryPassword}&quot;\n        }\n      } # end config\n      resources {\n        cpu    = 500\n        memory = ${memory}\n      } # end resources\n    } # end task\n    \n    task &quot;jenkins-dind-worker&quot; {\n      driver = &quot;docker&quot;\n\n      env {\n        DOCKER_TLS_CERTDIR = &quot;/certs&quot;\n      }\n\n      config {\n        image = &quot;${dockerInDockerImage}&quot;\n        privileged = true\n        volumes = [\n          &quot;/volumes/dind/jenkins-docker-certs:/certs/client&quot;,\n          &quot;/volumes/dind/jenkins-docker-certs-ca:/certs/ca&quot;\n        ]\n      } # end config\n      resources {\n      \tcpu    = 500\n      \tmemory = 256\n      } # end resources\n    } # end task\n    ephemeral_disk {\n      migrate = true\n      size    = 500\n      sticky  = true\n    } # end ephemeral disk\n  } # end group\n}"
  #$jobTemplate = "job &quot;%WORKER_NAME%&quot; {\n  region = &quot;global&quot;\n  datacenters = [&quot;dc1&quot;]\n  type = &quot;batch&quot;\n\n  group &quot;jenkins-worker-dind-taskgroup&quot; {\n    network {\n      mode = &quot;bridge&quot;\n    \n      port &quot;tcp&quot; {\n        to     = 2376\n      }\n    }\n    \n    task &quot;jenkins-worker&quot; {\n      driver = &quot;docker&quot;\n\n      env {\n        DOCKER_TLS_CERTDIR = &quot;/certs&quot;\n        JENKINS_URL = &quot;http://${jenkinsHost}:8080&quot;\n        JENKINS_AGENT_NAME = &quot;%WORKER_NAME%&quot;\n        JENKINS_SECRET = &quot;%WORKER_SECRET%&quot;\n        DOCKER_CERT_PATH = &quot;/certs/client&quot;\n        DOCKER_TLS_VERIFY =  &quot;1&quot;\n        DOCKER_HOST = &quot;tcp://127.0.0.1:\${NOMAD_PORT_tcp}&quot;\n      }\n\n      config {\n        image = &quot;${agentImage}&quot;\n        volumes = [\n          &quot;/volumes/dind/jenkins-docker-certs:/certs/client:ro&quot;,\n        ]\n      } # end config\n      resources {\n        cpu    = 500\n        memory = 256\n      } # end resources\n    } # end task\n    \n    task &quot;jenkins-dind-worker&quot; {\n      driver = &quot;docker&quot;\n\n      env {\n        DOCKER_TLS_CERTDIR = &quot;/certs&quot;\n      }\n\n      config {\n        image = &quot;${dockerInDockerImage}&quot;\n        privileged = true\n        volumes = [\n          &quot;/volumes/dind/jenkins-docker-certs:/certs/client&quot;,\n          &quot;/volumes/dind/jenkins-docker-certs-ca:/certs/ca&quot;\n        ]\n      } # end config\n      resources {\n      \tcpu    = 500\n      \tmemory = 256\n      } # end resources\n    } # end task\n    ephemeral_disk {\n      migrate = true\n      size    = 500\n      sticky  = true\n    } # end ephemeral disk\n  } # end group\n}"
  $changes = [
    "set slaveAgentPort/#text 50000",
    "set numExecutors/#text ${masterExecutors}",
    "rm clouds",
    "set ${subContext}/#attribute/plugin \"nomad@0.9.3\"",
    "set ${subContext}/name/#text Nomad",
    "set ${subContext}/instanceCap/#text 2147483647",
    "set ${subContext}/nomadUrl/#text ${nomadHost}",
    "touch ${subContext}/nomadACLCredentialsId",
    "set ${subContext}/prune/#text false",
    "set ${subContext}/tlsEnabled/#text false",
    "touch ${subContext}/clientCertificate",
    "set ${subContext}/clientPassword/#text {AQAAABAAAAAQPks6BsCbkggm5jwZPxagxwA/JuVDhnRG4xxPpYDdekA=}",
    "touch ${subContext}/serverCertificate",
    "set ${subContext}/serverPassword/#text {AQAAABAAAAAQOH0z1zU3NQ2j/OaG/S4JytiL17di1ysmBtElK4mhwGQ=}",
    "set ${subContext}/workerTimeout/#text ${nomadWorkerTimeout}",
    "set ${templateContext}/prefix/#text jenkins-nomad",
    "set ${templateContext}/idleTerminationInMinutes/#text 10",
    "set ${templateContext}/reusable/#text true",
    "set ${templateContext}/numExecutors/#text ${nomadTaskExecutors}",
    "set ${templateContext}/labels/#text '${labels}'",
    "set ${templateContext}/jobTemplate/#text '${jobTemplate}'",
    "touch ${templateContext}/remoteFs"
  ]

  augeas { "jenkins_general_config_clouds_nomad":
    show_diff => true,
    incl      => '/var/lib/jenkins/config.xml',
    lens      => 'Xml.lns',
    context   => '/files/var/lib/jenkins/config.xml/hudson/',
    changes   => $changes,
    require   => Package["jenkins"]
  }
  ->
  augeas::formatXML { "format /var/lib/jenkins/config.xml clouds-nomad":
    filepath => "/var/lib/jenkins/config.xml"
  }
}