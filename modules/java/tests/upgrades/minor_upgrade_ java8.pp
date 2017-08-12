Package{
  allow_virtual => false,
}

java{"java-8-31":
  major_version => "8",
  update_version => "31",
  multiTenancy => true,
  isDefault => true,
}

#java{"java-8-112":
#  major_version => "8",
#  update_version => "112",
#  multiTenancy => true,
#  isDefault => true,
#}
