# Class: alternatives
#
# This module manages alternatives
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
define alternatives::install(
  $executableName = undef,
  $executableLocation = undef,
  $priority = undef,
  $manExecutable = undef,
  $manLocation = undef,
  $execAlias = undef,
  $slaveBinariesHash = undef,
  $slaveManPagesHash = undef,
){
  #Decide which alternatives program we have based on OS
  if $::operatingsystem == 'CentOS' {
    $alternativesName = "/usr/sbin/alternatives"
  } elsif $::operatingsystem == 'Ubuntu' {
    if (versioncmp("${operatingsystemrelease}","14.04") == 0) or
    (versioncmp("${operatingsystemrelease}","18.04") == 0) {
      $alternativesName = "/usr/bin/update-alternatives"
    } else {
      $alternativesName = "/usr/sbin/update-alternatives"
    }
  } else {
    notify {"${::operatingsystem} is not supported":}
  }
  
  if (($manLocation != undef) and ($manExecutable != undef)){
    $slave = "--slave /usr/local/share/man/man1/${manExecutable} ${manExecutable} ${manLocation}${manExecutable}"
  }

  if ($execAlias != undef){ #some alternatives alias to the same executable, need to be able to use the desired exec name for the install and a different for the symlink 
    $targetExecutable = "${execAlias}"
  } else {
    $targetExecutable = "${executableName}"
  } 

  if ($slaveBinariesHash != undef){
    $slaveBinariesArray = $slaveBinariesHash.map |$key, $value| { "--slave /usr/bin/$key $key $value$key" }
    $binariesSlaves = $slaveBinariesArray.reduce |$memo, $value| { "$memo $value" }
  }

  if ($slaveManPagesHash != undef){
    $slaveManPagesArray = $slaveManPagesHash.map |$key, $value| { "--slave /usr/local/share/man/man1/$key $key $value$key" }
    $manPagesSlaves = $slaveManPagesArray.reduce |$memo, $value| { "$memo $value" }
  }

  exec {
    "${name}-install-alternative":
    command     => "${alternativesName} --install /usr/bin/${executableName} ${executableName} ${executableLocation}${targetExecutable} ${priority} ${slave} ${binariesSlaves} ${manPagesSlaves}",
    unless      => "${alternativesName} --display ${executableName} | /bin/grep ${executableLocation}${targetExecutable} > /dev/null",
    path        => '/usr/sbin/',
    cwd         => '/usr/sbin/',
  }
}

define alternatives::set(
  $executableName = undef,
  $executableLocation = undef,
  $execAlias = undef,
  $priority = undef,
  $slaveAlias = undef,
){
  #Decide which alternatives program we have based on OS
  if $::operatingsystem == 'CentOS' {
    $alternativesName = "/usr/sbin/alternatives"
  } elsif $::operatingsystem == 'Ubuntu' {
    if (versioncmp("${operatingsystemrelease}","14.04") == 0) or
      (versioncmp("${operatingsystemrelease}","18.04") == 0) {
      $alternativesName = "/usr/bin/update-alternatives"
    } else {
      $alternativesName = "/usr/sbin/update-alternatives"
    }
  } else {
    notify {"${::operatingsystem} is not supported":}
  }

  if ($execAlias != undef){ #some alternatives alias to the same executable, need to be able to use the desired exec name for the install and a different for the symlink
    $targetExecutable = "${execAlias}"
  } else {
    $targetExecutable = "${executableName}"
  }

  if ($slaveHash != undef){
    $slaveArray = $slaveHash.map |$key, $value| { "--slave /usr/bin/$key $key $value$key" }
    $slaves = $slaveArray.reduce |$memo, $value| { "$memo $value" }
  }

  exec {
    "set-alternative-${executableName}":
    command     =>  "${alternativesName} --set ${executableName} ${executableLocation}${targetExecutable} ${slaves}",
    unless      =>  "${alternativesName} --display ${executableName} | /bin/grep \"link currently points to ${executableLocation}${targetExecutable}\" > /dev/null",
    path        =>  '/usr/sbin/',
    cwd         =>  '/usr/sbin/',
  }
}

define alternatives::remove(
  $executableName = undef,
  $executableLocation = undef,
  $execAlias = undef,
  $priority = undef,
  $slaveAlias = undef,
  $onlyif = undef,
){
  #Decide which alternatives program we have based on OS
  if ("${operatingsystem}" == "CentOS") {
    $alternativesName = "/usr/sbin/alternatives"
  } elsif ("${operatingsystem}" == "Ubuntu") {
    if (versioncmp("${operatingsystemmajrelease}", "15.10") == 0) {
      $awk = "/bin/awk"
    } else {
      $awk = "/usr/bin/awk"
    }
    if (versioncmp("${operatingsystemrelease}","14.04") == 0) or
      (versioncmp("${operatingsystemrelease}","18.04") == 0) {
      $alternativesName = "/usr/bin/update-alternatives"
    } else {
      $alternativesName = "/usr/sbin/update-alternatives"
    }

  } else {
    notify {"${::operatingsystem} is not supported":}
  }

  if ($execAlias != undef){ #some alternatives alias to the same executable, need to be able to use the desired exec name for the install and a different for the symlink
    $targetExecutable = "${execAlias}"
  } else {
    $targetExecutable = "${executableName}"
  }

  if ($slaveHash != undef){
    $slaveArray = $slaveHash.map |$key, $value| { "--slave /usr/bin/$key $key $value$key" }
    $slaves = $slaveArray.reduce |$memo, $value| { "$memo $value" }
  }
  
  if ($onlyif != undef){
    $remove_onlyif = $onlyif
  } else {
    $remove_onlyif = "${alternativesName} --display ${executableName} | /bin/grep \"${executableLocation}${targetExecutable} - priority *\" > /dev/null"
  }
  
  exec {
    "remove-alternative-${executableName}-${executableLocation}":
      command     =>  "${alternativesName} --remove ${executableName} \$(${alternativesName} --display ${executableName}| /bin/grep \"${executableLocation}${targetExecutable} - priority *\" | ${awk} '{ print \$1 }')",
      onlyif      =>  "${remove_onlyif}",  
      path        =>  '/',
      cwd         =>  '/',
  }
}
#"/usr/sbin/alternatives --display firefox-javaplugin.so | /bin/grep \"link currently points to /usr/java/jdk1.8.0_*/jre/lib/amd64/firefox-javaplugin.so" > /dev/null",