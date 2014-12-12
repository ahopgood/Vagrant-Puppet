node 'demo'{
  file { '/tmp/hello': 
    content =>  "Hello node world\n",
  }
  
  notify{ 'Configuring the test node': 
    require =>  File['/tmp/hello']
  }
    
}
