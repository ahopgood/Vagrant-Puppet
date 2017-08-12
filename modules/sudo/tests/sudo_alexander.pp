$username = "alexander"
group {"${username}":
  ensure => present,
}
->
user {"${username}":
  name => "${username}",
  ensure => present,
  home => "/home/${username}/",
  shell => "/bin/bash",
  managehome => true,
  groups => "${username}",
  password => '$6$tLMwUR89$oiJYeHsjdB2Mkv7VJY5MJbq/2tG8i3rtO3lRL5zZT2VD4SH5J6U2TG1OT1I/S8uCwrwC5z.Q8icX4jVcP0Tmf/'
}

sudo {"${username}":}