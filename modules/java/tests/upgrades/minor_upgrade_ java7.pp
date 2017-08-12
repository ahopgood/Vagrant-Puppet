Package{
  allow_virtual => false,
}

java{"java-7-76":
  major_version => "7",
  update_version => "76",
  multiTenancy => true,
  isDefault => true,
}

#java{"java-7-80":
#  major_version => "7",
#  update_version => "80",
#  multiTenancy => true,
#  isDefault => true,
#}
