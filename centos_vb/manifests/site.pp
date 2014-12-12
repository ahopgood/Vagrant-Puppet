
import 'nodes.pp'

#sudo hostname demo
#sudo su -c 'echo demo' > /etc/hostname'
#Seems to have permissions issues, shouldn't su solve this.
#logout to see hostname set to demo

#ip addr list | grep eth0$
#sudo su -c 'echo 192.168.33.11 demo demo.example.domain >> /etc/hosts'

/*
node 'test' {
  file { '/tmp/hello': 
    content =>  "Hello test world\n",
  }
 
  notify{ 'Configuring the test node': 
    require =>  File['/tmp/hello']
  }
}  
*/
/* 
node 'demo'{
  notify{ 'Configuring the demo node': }
}
*/

/* 
node java{
  include java
}

node tomcat7{
    class { 'tomcat::tomcat7':
    tomcat_manager_username =>  'admin',
    tomcat_manager_password =>  'adminadmin',
    logging_directory =>  '/var/log/tomcat7',
  }  
}
*/