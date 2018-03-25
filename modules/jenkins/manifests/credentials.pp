class jenkins::credentials {
  $credentials_file = "/var/lib/jenkins/credentials.xml"
  @file {"${credentials_file}":
    ensure => present,
    mode => "755",
    group => "jenkins",
    owner => "jenkins",
    content => "<?xml version='1.0' encoding='UTF-8'?>\n<com.cloudbees.plugins.credentials.SystemCredentialsProvider></com.cloudbees.plugins.credentials.SystemCredentialsProvider>",
  }

  @augeas { "jenkins_credentials_config":
    show_diff => true,
    incl      => "${credentials_file}",
    lens      => "Xml.lns",
    context   => "/files/var/lib/jenkins/credentials.xml/com.cloudbees.plugins.credentials.SystemCredentialsProvider/",
    require   => [File["${credentials_file}"]],
    changes   => [
      "set #attribute/plugin credentials@2.1.6",
      "set domainCredentialsMap/#attribute/class hudson.util.CopyOnWriteMap\$Hash",
      "set domainCredentialsMap/entry/com.cloudbees.plugins.credentials.domains.Domain/specifications #empty", #common to all credentials
    ]
  }

}
define jenkins::credentials::ssh (
  $key_name = undef, #hiera key_name
  $ssh_creds_name = undef,
){
  include jenkins::credentials
  $ssh_private_key = hiera("jenkins::credentials::ssh::private_key::${key_name}",'test')
  realize(File["${jenkins::credentials::credentials_file}"])
  realize(Augeas["jenkins_credentials_config"])

  augeas { 'jenkins_ssh_credentials_config':
    show_diff => true,
    incl      => "${jenkins::credentials::credentials_file}",
    lens      => 'Xml.lns',
    context   => '/files/var/lib/jenkins/credentials.xml/com.cloudbees.plugins.credentials.SystemCredentialsProvider/domainCredentialsMap/entry/java.util.concurrent.CopyOnWriteArrayList/com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey/',
    require   => [File["${jenkins::credentials::credentials_file}"],
      Augeas["jenkins_credentials_config"]],
    changes   => [
      "set #attribute/plugin ssh-credentials@1.13",
      "set scope/#text \"GLOBAL\"",
      "set id/#text \"${ssh_creds_name}\"",
      "set description/#text \"The SSH user that represents Jenkins when deploying to other systems\"",
      "set username/#text \"${key_name}\"",
      "set privateKeySource/#attribute/class \"com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey\$DirectEntryPrivateKeySource\"",
      "set privateKeySource/privateKey/#text \"${ssh_private_key}\""
    ]
  }
  ->
  augeas::formatXML{"format ${jenkins::credentials::credentials_file} jenkins_ssh_credentials_config ${key_name}":
    filepath => "${jenkins::credentials::credentials_file}"
  }
}

define jenkins::credentials::gitCredentials(
  $git_hub_api_token = hiera('jenkins::gitCredentials::git_hub_api_token','test'),
  $token_name = undef,
) {
  include jenkins::credentials
  # $credentials_file = "/var/lib/jenkins/credentials.xml"
  realize(File["${jenkins::credentials::credentials_file}"])
  realize(Augeas["jenkins_credentials_config"])

  augeas { 'jenkins_git_credentials_config':
    show_diff => true,
    incl      => "${jenkins::credentials::credentials_file}",
    lens      => 'Xml.lns',
    context   => '/files/var/lib/jenkins/credentials.xml/com.cloudbees.plugins.credentials.SystemCredentialsProvider/domainCredentialsMap/entry/java.util.concurrent.CopyOnWriteArrayList/com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl/',
    require   => [File["${jenkins::credentials::credentials_file}"],
      Augeas["jenkins_credentials_config"]],
    changes   => [
      "set scope/#text \"GLOBAL\"",
      "set id/#text \"${token_name}\"",
      "set description/#text \"Github api token\"",
      "set username/#text \"ahopgood\"",
      "set password/#text \"${git_hub_api_token}\"",
    ]
  }
  ->
  augeas::formatXML{"format ${jenkins::credentials::credentials_file}":
    filepath => "${jenkins::credentials::credentials_file}"
  }
}