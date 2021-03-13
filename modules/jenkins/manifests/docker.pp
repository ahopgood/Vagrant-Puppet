class jenkins::docker {}

/**
 Tooling to define the org.jenkinsci.plugins.docker.workflow.declarative.GlobalConfig.xml file.
 This file sets up the declarative jenkins pipeline to work with docker
*/
define jenkins::docker::workflow(
  $credentials_name = "docker",
  $registry_address = hiera('jenkins::dockerRegistry::address', 'test-address')
) {

  $docker_workflow_file = "/var/lib/jenkins/org.jenkinsci.plugins.docker.workflow.declarative.GlobalConfig.xml"
  file {"${docker_workflow_file}":
    ensure => present,
    mode => "755",
    group => "jenkins",
    owner => "jenkins",
    content => "<?xml version='1.0' encoding='UTF-8'?>\n<org.jenkinsci.plugins.docker.workflow.declarative.GlobalConfig plugin=\"docker-workflow@1.25\">\n</org.jenkinsci.plugins.docker.workflow.declarative.GlobalConfig>",
    require => [
      Package["jenkins"],
    ]
  }

  augeas { "jenkins_docker_worklfow_config ${credentials_name}":
    show_diff => true,
    incl      => "${docker_workflow_file}",
    lens      => "Xml.lns",
    context   => "/files${docker_workflow_file}/org.jenkinsci.plugins.docker.workflow.declarative.GlobalConfig/",
    require   => [File["${docker_workflow_file}"],
      Package["jenkins"]
    ],
    changes   => [
      "set dockerLabel/#text \"Docker\"",
      "set registry/#attribute/plugin  \"docker-commons@1.17\"",
      "set registry/url/#text \"https://${registry_address}/\"",
      "set registry/credentialsId/#text \"${credentials_name}\"",
    ]
  }
  ->
  augeas::formatXML{"format ${docker_workflow_file} jenkins_docker_worklfow_config ${credentials_name}":
    filepath => "${docker_workflow_file}"
  }
}

/**
 Tooling to define the org.jenkinsci.plugins.docker.commons.tools.DockerTool.xml file.
 Sets up the global configuration to specify where docker is located
*/
define jenkins::docker::global {

  $docker_tool_file = "/var/lib/jenkins/org.jenkinsci.plugins.docker.commons.tools.DockerTool.xml"
  file {"${docker_tool_file}":
    ensure => present,
    mode => "755",
    group => "jenkins",
    owner => "jenkins",
    content => "<?xml version='1.0' encoding='UTF-8'?>\n<org.jenkinsci.plugins.docker.commons.tools.DockerTool_-DescriptorImpl plugin=\"docker-commons@1.17\">\n</org.jenkinsci.plugins.docker.commons.tools.DockerTool_-DescriptorImpl>",
    require => [
      Package["jenkins"],
    ]
  }

  augeas { 'jenkins_docker_global_tool_config':
    show_diff => true,
    incl      => "${docker_tool_file}",
    lens      => 'Xml.lns',
    context   => "/files${docker_tool_file}/org.jenkinsci.plugins.docker.commons.tools.DockerTool_-DescriptorImpl/",
    require   => [File["${docker_tool_file}"],
      Package["jenkins"]
    ],
    changes   => [
      "set installations/#attribute/class \"org.jenkinsci.plugins.docker.commons.tools.DockerTool-array\"",
      "set installations/org.jenkinsci.plugins.docker.commons.tools.DockerTool/name/#text \"docker-ce\"",
      "set installations/org.jenkinsci.plugins.docker.commons.tools.DockerTool/home/#text \"/usr/bin/\"",
      "set installations/org.jenkinsci.plugins.docker.commons.tools.DockerTool/properties  #empty",
    ]
  }
  ->
  augeas::formatXML{"format ${docker_tool_file} jenkins_docker_global_tool_config":
    filepath => "${docker_tool_file}"
  }

  $registry_address = hiera('jenkins::dockerRegistry::address', 'test-address')
  $changes = [
    "rm globalNodeProperties",
    "set globalNodeProperties/hudson.slaves.EnvironmentVariablesNodeProperty/envVars/#attribute/serialization \"custom\"",
    "set globalNodeProperties/hudson.slaves.EnvironmentVariablesNodeProperty/envVars/unserializable-parents #empty",
    "set globalNodeProperties/hudson.slaves.EnvironmentVariablesNodeProperty/envVars/tree-map/default/comparator  #empty",
    "set globalNodeProperties/hudson.slaves.EnvironmentVariablesNodeProperty/envVars/tree-map/default/comparator/#attribute/class \"hudson.util.CaseInsensitiveComparator\"",
    "set globalNodeProperties/hudson.slaves.EnvironmentVariablesNodeProperty/envVars/tree-map/int/#text \"1\"",
    "set globalNodeProperties/hudson.slaves.EnvironmentVariablesNodeProperty/envVars/tree-map/string[1]/#text \"DOCKER_REGISTRY\"",
    "set globalNodeProperties/hudson.slaves.EnvironmentVariablesNodeProperty/envVars/tree-map/string[2]/#text  \"${registry_address}\"",
  ]

  augeas { "jenkins_general_config_env_var_docker_registry":
    show_diff => true,
    incl      => '/var/lib/jenkins/config.xml',
    lens      => 'Xml.lns',
    context   => '/files/var/lib/jenkins/config.xml/hudson/',
    changes   => $changes,
  }
  ->
  augeas::formatXML { "format /var/lib/jenkins/config.xml docker-registry":
    filepath => "/var/lib/jenkins/config.xml"
  }
}

define jenkins::docker::group {
  exec {"docker":
    command => "usermod -a -G docker jenkins",
    path => "/usr/sbin/",
    # notify => Service["jenkins"]
    # Use jenkins::global::restart instead
  }
  ->
  exec {"restart jenkins":
    command => "systemctl restart jenkins",
    path => "/bin/",
  }
}
