Package{
  allow_virtual => false,
}
$local_install_path = "/etc/puppet/"
$local_install_dir = "${local_install_path}installers/"
$puppet_file_dir = "modules/java/"

file {
  "${local_install_dir}":
    path       =>  "${local_install_dir}",
    ensure     =>  directory,
}

# java::openjdk::ubuntu::xenial {"java8":
#   major_version => "8",
#   update_version => "232",
#   # isDefault => true,
#   # multiTenancy => false,
#   multiTenancy => true,
# }
# ->
# java::openjdk::ubuntu::xenial {"java11":
#   major_version => "11",
#   update_version => "5",
#   # isDefault => true,
#   # multiTenancy => false,
#   multiTenancy => true,
# }

# java::ubuntu{"AdoptOpenJdk test via the Java::Ubuntu resource":
#   major_version => "8",
#   update_version => "232",
#   multiTenancy => true
# }
# sudo puppet apply --parser=future /vagrant/tests/openjdk.pp
# java {"Oracle test via the Java resource":
#   major_version => "8",
#   update_version => "212",
#   multiTenancy => false,
#   isDefault => false,
# }
# ->
# java {"AdoptOpenJdk test via the Java resource":
#   major_version => "8",
#   update_version => "242",
# }
# ->
# java::jce {"jce8":
#   major_version => "8",
#   update_version => "242",
# }
# ->
java {"AdoptOpenJdk 11 test via the Java resource":
  major_version => "11",
  update_version => "6",
  # multiTenancy => true,
  # isDefault => false,
}
# ->
# java::openjdk::ubuntu::create_default{"test-11-create":
#   major_version => "8",
# }
# ->
java::openjdk::ubuntu::set_default{"test-11-set":
  major_version => "11",
}