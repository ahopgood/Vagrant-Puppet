Package{
  allow_virtual => false,
}


$local_install_path = "/etc/puppet/"
$local_install_dir = "${local_install_path}installers/"

file {
  "${local_install_dir}":
    path       =>  "${local_install_dir}",
    ensure     =>  directory,
}

class{"unzip":}

java {"java-6":
  major_version => "6",
  update_version => "45",
  multiTenancy => true,
}
->
java::jce {"jce6":
  major_version => "6",
  update_version => "45",
}
->
java {"java-7":
  major_version => "7",
  update_version => "76",
  multiTenancy => true,
}
->
java::jce {"jce7":
  major_version => "7",
  update_version => "76",
}
->
java {"java-8":
  major_version => "8",
  update_version => "31",
  multiTenancy => true,
}
->
java::jce {"jce8":
  major_version => "8",
  update_version => "31",
}