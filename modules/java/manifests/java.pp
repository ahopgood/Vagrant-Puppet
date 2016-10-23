Package{
  allow_virtual => false,
}

java{"java-7":
  version => '7',
  updateVersion => '76'
}
#
#    
#java{"java-6":
#  version => "6",
#  updateVersion => "45"
#}

java::ubuntu{"java-6":
  version => "6",
  updateVersion => "45"
}