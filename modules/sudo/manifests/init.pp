class sudo (
  $username = undef
) {
  #Make use of realize keyword for the user and authorized key?

  if ($username == undef){
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

  file {"/etc/sudoers.d/${username}":
    ensure => present,
    content => "alexander ALL=(ALL) NOPASSWD:ALL",
    require => User["${username}"]
  }
}


#group {"alexander":
#  ensure => present,
#}
#->
#user {"alexander":
#  name => "alexander",
#  ensure => present,
#  home => "/home/alexander/",
#  shell => "/bin/bash",
#  managehome => true,
#  groups => "alexander",
#}
#->
#ssh_authorized_key { 'alexander@Buzzsaw':
#  ensure => present,
#  user   => 'alexander',
#  type   => 'ssh-rsa',
#  key    => 'AAAAB3NzaC1yc2EAAAADAQABAAACAQCz8x16AypTn56nE39U/USHSasbttFGCrzP0PlwWMfAp5mrURO9DpuqrEG1qNcAxIfQ3LhppkRoSIcbsn6NYwlEskyNZgEjN1Xl89ZQtVhF84kAjEXmg3r2osKXlSRt78PBxPped9ssgfgh6p7mbaBtqqhmU6i35PGgeJL1pxBVfXCacNiBTlOeyyIS7GeYUXM2PKCHpQHpBuqzS5kqPTGODB04Jhp+3bprpiR1GVuGZcRkCXjJI6dvrB17dpvYcSC5VgNlIJe7kcP8L+a0a+PzGFM1XXLd3zY4ygpjxI/NPxhgYCSvW0SUX38HSplgUgdBU3eUHCyk1RA5g7+3LVWuKWPCFNmHTuMgelpCZPwdcgUmQVH6q6/2LNlV7z3U0Yrty7m9tkxV9QpBYmphI5axGY0phyJoN1gxnSg+xJJaKIadozRmCWnBE7Ext3ZuSZ3eaUOkwE1hSMoPzGn3uTng1bxTePeuH3PDbBLVaFm1zTKJyhkIbmYxY0vK6AxUlkzebJaew86n+0nMR0k3ZlpwEcYuv1UnX8PjAmEBEg8YdZjMmTdIDhCntd0dr+IW0llsXEqFYzuZuHU7BXFsk8+bX9agMoBkMH1EnXG4Z/OefDaaH80SLQStXKuauQc6ORgbbXiZU3Pb/gUH+IuX6z9UyYFx2+Wk1j4+AhPnlowd8w==',
#}
#->
#file {"/etc/sudoers.d/alexander":
#  ensure => present,
#  content => "alexander ALL=(ALL) NOPASSWD:ALL",
#}
#->
#ufw {"open-ssh-port":
#  port => '22',
#  isTCP => true
#}
#->
#ufw::service{"ufw-service":}