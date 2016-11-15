
  Package{
    allow_virtual => false,
  }
  
  java{"java-7":
    version => '7',
    updateVersion => '76',
    multiTenancy => true,
  }
  ->
  java::default::set{"set-default-to-java-7":
    version => "7",
  }
  java{"java-8":
    version => "8",
    updateVersion => "31",
    multiTenancy => true,
  }
#  ->
#  java::default::install{"install-default-to-java-8":
#    version => "8",
#  }
#  ->
#  exec {"ouput-install":
#    path => "/bin/",
#    command => "ls -l /etc/alternatives | grep jvm | /usr/bin/awk '{ print $9 }' > /vagrant/test.txt"
#  }
#  ->
#  java::default::set{"set-default-to-java-8":
#    version => "8",
#  }

  java::ubuntu{"java-6":
    version => "6",
    updateVersion => "45",
    multiTenancy => true,
  }
#  ->
#  java::default::set{"set-default-to-java-6":
#    version => "6",
#  }
  #java{"java-8":
  #  version => "8",
  #  updateVersion => "112",
  ##  multiTenancy => true,
  #}