user {"alexander":
  name => "alexander",
  ensure => present,
  home => "/home/alexander/",
  shell => "/bin/bash",
  managehome => true,
  groups => "alexander",
}

class {"sudo":
  #missing username => "alexander
}