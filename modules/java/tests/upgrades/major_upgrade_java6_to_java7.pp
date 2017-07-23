Package{
  allow_virtual => false,
}

java{"java-6-45":
  major_version => "6",
  update_version => "45",
  multiTenancy => true,
  isDefault => true,
}

#java{"java-7-80":
#  major_version => "7",
#  update_version => "80",
#  isDefault => true,
#  multiTenancy => true,
#}

