define sudo (
) {
  #Make use of realize keyword for the user and authorized key?

  if ($title == undef){
    fail("A username is required in order to provide sudo privileges")
  }
  if (versioncmp($operatingsystem, "CentOS") == 0){
    if (versioncmp($operatingsystemmajrelease, "6") == 0){
      
    } elsif (versioncmp($operatingsystemmajrelease, "7") == 0){
 
    } else {
      fail("sudo is currently not supported on $operatingsystemmajrelease $operatingsystemmajrelease")
    }
  } elsif (versioncmp($operatingsystem, "Ubuntu") == 0){
    if (versioncmp($operatingsystemmajrelease, "15.10") == 0){
      
    } else {
      fail("sudo is currently not supported on $operatingsystemmajrelease $operatingsystemmajrelease")
    }
  } else {
    fail("sudo is currently not supported on $operatingsystemmajrelease $operatingsystemmajrelease")
  }

  file {"/etc/sudoers.d/${title}":
    ensure => present,
    content => "alexander ALL=(ALL) NOPASSWD:ALL",
    require => User["${title}"]
  }
}

define sudo::remove(){
  if ($title == undef){
    fail("A username is required in order to provide sudo privileges")
  }
  if (versioncmp($operatingsystem, "CentOS") == 0){
    if (versioncmp($operatingsystemmajrelease, "6") == 0){

    } elsif (versioncmp($operatingsystemmajrelease, "7") == 0){

    } else {
      fail("sudo is currently not supported on $operatingsystemmajrelease $operatingsystemmajrelease")
    }
  } elsif (versioncmp($operatingsystem, "Ubuntu") == 0){
    if (versioncmp($operatingsystemmajrelease, "15.10") == 0){

    } else {
      fail("sudo is currently not supported on $operatingsystemmajrelease $operatingsystemmajrelease")
    }
  } else {
    fail("sudo is currently not supported on $operatingsystemmajrelease $operatingsystemmajrelease")
  }
  
#  file {"/etc/sudoers.d/${title}":
#    ensure => absent,
#  }
  
  exec {"Remove sudo file /etc/sudoers.d/${title}":
    path => "/bin/",
    cwd => "/etc/sudoers.d/",
    command => "rm ${title}",
    onlyif => "ls /etc/sudoers.d/${title}",
  }
}