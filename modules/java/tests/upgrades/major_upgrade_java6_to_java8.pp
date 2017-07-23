Package{
  allow_virtual => false,
}

java{"java-6-45":
  major_version => "6",
  update_version => "45",
  multiTenancy => true,
  isDefault => true,
}

#java{"java-8-112":
#  major_version => "8",
#  update_version => "112",
#  isDefault => true,
#  multiTenancy => true,
#}

