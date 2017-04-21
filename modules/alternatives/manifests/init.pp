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
  $slaveHash = undef,
){
  #Decide which alternatives program we have based on OS
  if $::operatingsystem == 'CentOS' {
    $alternativesName = "alternatives"
  } elsif $::operatingsystem == 'Ubuntu' {
    $alternativesName = "update-alternatives"
  } else {
    notify {"${::operatingsystem} is not supported":}
  }
  
  if (($manLocation != undef) and ($manExecutable != undef)){
    $slave = "--slave /usr/bin/${manExecutable} ${manExecutable} ${manLocation}${manExecutable}"
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
    "${name}-install-alternative":
    command     =>  "${alternativesName} --install /usr/bin/${executableName} ${executableName} ${executableLocation}${targetExecutable} ${priority} ${slave} ${slaves}",
    unless      => "/usr/sbin/${alternativesName} --display ${executableName} | /bin/grep ${executableLocation}${targetExecutable} > /dev/null",
    path        =>  '/usr/sbin/',
    cwd         =>  '/usr/sbin/',
  }
}

define alternatives::set(
  $executableName = undef,
  $executableLocation = undef,
  $execAlias = undef,
  $priority = undef,
){
  #Decide which alternatives program we have based on OS
  if $::operatingsystem == 'CentOS' {
    $alternativesName = "alternatives"
  } elsif $::operatingsystem == 'Ubuntu' {
    $alternativesName = "update-alternatives"
  } else {
    notify {"${::operatingsystem} is not supported":}
  }

  if ($execAlias != undef){ #some alternatives alias to the same executable, need to be able to use the desired exec name for the install and a different for the symlink
    $targetExecutable = "${execAlias}"
  } else {
    $targetExecutable = "${executableName}"
  }

  exec {
    "set-alternative-${executableName}":
    command     =>  "${alternativesName} --set ${executableName} ${executableLocation}${targetExecutable}",
    unless      =>  "/usr/sbin/${alternativesName} --display ${executableName} | /bin/grep \"link currently points to ${executableLocation}${targetExecutable}\" > /dev/null",
    path        =>  '/usr/sbin/',
    cwd         =>  '/usr/sbin/',
  }
}
