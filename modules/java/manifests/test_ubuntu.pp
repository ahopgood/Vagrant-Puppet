
  Package{
    allow_virtual => false,
  }
  
#  java{"java-7":
#    version => '7',
#    updateVersion => '76',
#    multiTenancy => true,
#  }
  
  java{"java-8":
    version => "8",
    updateVersion => "31",
    multiTenancy => true,
  }
  ->
  java::ubuntu::default{"set-default-to-java-8":
    version => "8",
  }

#  java::ubuntu{"java-6":
#    version => "6",
#    updateVersion => "45",
#    multiTenancy => true,
#  }
  #java{"java-8":
  #  version => "8",
  #  updateVersion => "112",
  ##  multiTenancy => true,
  #}