Package{
  allow_virtual => false,
}

java{"java-6-34":
  major_version => "6",
  update_version => "34",
  multiTenancy => true,
  isDefault => true,
}

#java{"java-6-45":
#  major_version => "6",
#  update_version => "45",
#  isDefault => true,
#  multiTenancy => true,
#}

