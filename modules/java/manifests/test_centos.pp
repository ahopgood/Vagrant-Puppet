  Package{
    allow_virtual => false,
  }

  java{"java-7":
    version => '7',
    updateVersion => '76',
#    multiTenancy => true,
  }
  ->
  java::default::install{"install-jdk-7-as-default":
    version => "7",
    updateVersion => '76',
  }
      
# java{"java-8":
#   version => "8",
#   updateVersion => "31",
#   multiTenancy => true,
# }
  
#  java{"java-6":
#    version => "6",
#    updateVersion => "45",
#    multiTenancy => true,
#  }
