class agentweb {
  /*
    class { 'tomcat::tomcat7':
    tomcat_manager_username =>  'admin',
    tomcat_manager_password =>  'adminadmin',
    logging_directory =>  '/var/log/tomcat7',
  }
  */
  
  service { "iptables":
    ensure    =>  stopped,
    enable    =>  false,
  } 
}

include agentweb