Package{
  allow_virtual => false
}

$local_install_path = "/etc/puppet/"
$local_install_dir = "${local_install_path}installers/"

file {
  "${local_install_dir}":
    path       =>  "${local_install_dir}",
    ensure     =>  directory,
}

class {"augeas":}
->
class{"ddclient":
  protocol => "namecheap",
  use => "web, web=dynamicdns.park-your-domain.com/getip",
  ssl => "yes",
  server => "dynamicdns.park-your-domain.com",
  login => "alexanderhopgood.com",
  password => "ffffffffffffffffffffffffffffffff",
  domains => "projects.alexanderhopgood.com",
}
