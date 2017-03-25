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
class{"ddclient":}
->
ddclient::entry{"alexanderhopgood.com":
  protocol => "namecheap",
  use => "web, web=dynamicdns.park-your-domain.com/getip",
  ssl => "yes",
  server => "dynamicdns.park-your-domain.com",
  login => "alexanderhopgood.com",
  password => "ffffffffffffffffffffffffffffffff",
  domains => "projects.alexanderhopgood.com",
  remove_package_conf => true,
}
->
ddclient::entry{"alexanderhopgood.co.uk":
  protocol => "namecheap",
  use => "web, web=dynamicdns.park-your-domain.com/getip",
  ssl => "yes",
  server => "dynamicdns.park-your-domain.com",
  login => "alexanderhopgood.co.uk",
  password => "ffffffffffffffffffffffffffffffff",
  domains => "projects.alexanderhopgood.co.uk",
}
#(* let comment = [ label "comment" . store /(\#[a-zA-Z]*)/ . eol ] *)
#(* let comments = [ seq "comments" . comment+ ] *)
