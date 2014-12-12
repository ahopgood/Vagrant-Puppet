node 'agentdb' {
  notify { 'Configuring the management of the database server': }

  include mysql
  
  notify {  'Database server configuration finished':  }
}

node 'agentweb' {
  notify {  'Configuring the management of the web application server': }
  
  class { 'tomcat::tomcat7':
    tomcat_manager_username =>  'admin',
    tomcat_manager_password =>  'adminadmin',
    logging_directory       =>  '/var/log/tomcat7',
  }   
}

node 'agent' {
  notify { 'Started agent node!' : }
}

node 'localhost'{
  notify { 'Running in localhost mode' : }
}

  service { "iptables":
    enable  =>  false,
    ensure  => stopped,
  }
