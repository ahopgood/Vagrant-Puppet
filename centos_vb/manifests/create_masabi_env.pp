$env  = "dev"
$tis  = "atos"

group {
  'conf':
  ensure  =>  present,
}

user {
  'installer':
  ensure      =>  present,
  gid         =>  'conf',
  home        =>  '/home/installer',
  managehome  =>  true,
  shell       =>  '/bin/bash',  
}

file {
    '/test-conf.properties':
    ensure  =>  file,
    source  =>  ['puppet:///configuration_files/test.properties'],
#'/configuration_files/test.properties'],
}

#Setup masabi-config folder
file {
    ['/opt/masabi-config/',
     "/opt/masabi-config/${tis}/","/opt/masabi-config/${tis}/${env}"]:
    ensure  =>  directory,
    mode    =>  0644,
    owner   =>  'installer',
}

#Setup masabi networking keys
file {
    ['/opt/masabi-keys/']:
    ensure  =>  directory,
    mode    =>  0644,
    owner   => 'installer',
}

#Setup tomcat user 
user {
  'tomcat':
  ensure      =>  present,
  gid         =>  'conf',
  home        =>  '/home/tomcat',
  managehome  =>  true,
  shell       =>  '/bin/bash',  
}

#Setup tomcat logging location
file {
    ['/var/hosting','/var/hosting/tomcat','/var/hosting/tomcat/logs']:
    ensure  =>  directory,
    mode    =>  0644,
    recurse =>  true,
    owner   =>  'tomcat',
    group   =>  'conf',
    before  => File['/var/tomcat6/','/var/tomcat7/'],
}

#Setup links for our application tomcat6 logging
#Need to setup the tomcat group as the owner of these folders
file {
    ['/var/tomcat6/','/var/tomcat7/']:
    ensure  =>  directory,
    mode    =>  0644,
    owner   =>  'tomcat',
    group   =>  'conf',
    before  => File['/var/tomcat6/logs/','/var/tomcat7/logs/'],
}
  
file {
    ['/var/tomcat6/logs/','/var/tomcat7/logs']:
    ensure  =>  link,
    owner   =>  'tomcat',
    group   =>  'conf',
    target  =>  '/var/hosting/tomcat/logs',
 }  
