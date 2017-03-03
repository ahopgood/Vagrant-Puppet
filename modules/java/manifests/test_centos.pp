  Package{
    allow_virtual => false,
  }

    
#  java{"java-8":
#    version => "8",
#    update_version => "31",
##    multiTenancy => true,
#  }

#  java{"java-8":
#    version => "8",
#    update_version => "112",
##    multiTenancy => true,
#  }

#  java{"java-7":
#    version => '7',
#    update_version => '80',
##    multiTenancy => true,
##    isDefault => true,
#  }

#  java{"java-7":
#    version => '7',
#    update_version => '76',
##    multiTenancy => true,
##    isDefault => true,
#  }
  
#  java{"java-6":
#    version => "6",
#    update_version => "45",
##    multiTenancy => true,
#  }

  java{"java-6":
    version => "6",
    update_version => "34",
#    multiTenancy => true,
  }

#  java{"java-5":
#    version => "5",
#    update_version => "22",
##    isDefault => true,
##    multiTenancy => true,
#  }
  
#  java{"java-5":
#    version => "5",
#    update_version => "20",
##    isDefault => true,
##    multiTenancy => true,
#  }

#sudo puppet apply /vagrant/manifests/test_centos.pp






    #jdk1.8.0_25-1.8.0_25-fcs.x86_64
    #jdk-1.7.0_71-fcs.x86_64
    #jdk-1.6.0_45-fcs.x86_64
    #jdk-1.5.0_22-fcs.x86_64

#      $versionsToRemove = {
##        "6" => ["oracle-java7-jdk","oracle-java8-jdk"],
#        "6" => ["1.7.0_*-fcs","1.8.0_*-fcs"],
##        "6" => ["jdk-1.7.0_*-fcs","jdk1.8.0_*-fcs"],
##        "7" => ["oracle-java6-jdk","oracle-javajdk8-jdk"],
#        "7" => ["1.6.0_*-fcs","1.8.0_31-fcs"],
##        "7" => ["jdk- 1.6.0_*-fcs","jdk1.8.0_31-fcs"],        
##        "8" => ["oracle-java6-jdk","oracle-java7-jdk"],
#        "8" => ["1.6.0_*-fcs", "1.7.0_*-fcs"],
##        "8" => ["jdk-1.6.0_*-fcs", "jdk-1.7.0_*-fcs"],
#      }   
#      
#      package {
##        "1.${version}.0_*-fcs":
#        $versionsToRemove["${version}"]:
#        ensure  => absent,
#        provider => 'rpm'
#      }      
