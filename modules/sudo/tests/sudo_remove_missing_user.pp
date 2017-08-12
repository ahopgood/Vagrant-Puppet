$username = "alexander"
#user {"${username}":
#  name => "${username}",
#  ensure => present,
#  home => "/home/${username}/",
#  shell => "/bin/bash",
#  managehome => true,
#  groups => "${username}",
#}
# missing user
sudo::remove {"${username}":}