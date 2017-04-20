Package{
  allow_virtual => false,
}

#java{"java-7-80":
#  major_version => "7",
#  update_version => "80",
#  multiTenancy => true,
#  isDefault => true,
#}

java{"java-8-31":
  major_version => "8",
  update_version => "111",
  isDefault => true,
  multiTenancy => true,
}

#java{"java-8-112":
#  major_version => "8",
#  update_version => "112",
#  isDefault => true,
#  multiTenancy => true,
#}
