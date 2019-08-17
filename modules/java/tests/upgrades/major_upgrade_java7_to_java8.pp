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

java{"java-7-80":
 major_version => "7",
 update_version => "80",
 multiTenancy => true,
 isDefault => true,
}

# java{"java-8-31":
#   major_version => "8",
#   update_version => "31",
#   isDefault => true,
#   multiTenancy => true,
# }

#java{"java-8-112":
#  major_version => "8",
#  update_version => "112",
#  isDefault => true,
#  multiTenancy => true,
#}
