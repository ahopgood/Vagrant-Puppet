define httpd::virtual_host(
  $server_name = undef,
  $document_root = undef,
){

  Httpd::Virtual_host <| |>
  ->
  Class["httpd"]

  #mkdir $document_root
  #cp index.html

  #Create the symbolic link form our *.conf in available to enabled.

  #Use augeas to add the following to the /etc/httpd/conf/httpd.conf file if not present
  #IncludeOptional sites-enabled/*.conf
  $host_changes = [
    "set directive[last()+1] IncludeOptional",
    "set directive[last()]/arg[1] sites-enabled/*.conf",
  ]

  augeas { "load httpd.conf":
    incl    => "/etc/httpd/conf/httpd.conf",
    lens    => "Httpd.lns",
    context => "/files/etc/httpd/conf/httpd.conf/",
    changes => $host_changes,
    onlyif  => "match /files/etc/httpd/conf/httpd.conf/directive[. = 'IncludeOptional']/arg[. = 'sites-enabled/*.conf'] size == 0",
  }

  #Create the /etc/httpd/sites-enabled/ directory
  file { "sites-enabled directory for ${name} virtual host":
    ensure => directory,
    path   => "/etc/httpd/sites-enabled",
  }

  #Create the /etc/httpd/sites-available/ directory
  file { "sites-available directory for ${name} virtual host":
    ensure => directory,
    path   => "/etc/httpd/sites-available",
  }

  if ("${server_name}" == undef){
    fail("A server_name is needed for creating a virtual host")
  }
  if ("${document_root}" == undef){
    fail("A document_root is needed for creating a virtual host")
  }


  file {"${server_name}.conf":
    ensure => present,
    path => "/etc/httpd/sites-available/${server_name}.conf",
  }

  #Create sitename.conf file with virtual host conf in it.
/*
/files/etc/httpd/sites-available/www.alex.com.conf
/files/etc/httpd/sites-available/www.alex.com.conf/VirtualHost
/files/etc/httpd/sites-available/www.alex.com.conf/VirtualHost/arg = "*:80"
/files/etc/httpd/sites-available/www.alex.com.conf/VirtualHost/directive[1] = "DocumentRoot"
/files/etc/httpd/sites-available/www.alex.com.conf/VirtualHost/directive[1]/arg = "\"/www/alex/\""
/files/etc/httpd/sites-available/www.alex.com.conf/VirtualHost/directive[2] = "ServerName"
/files/etc/httpd/sites-available/www.alex.com.conf/VirtualHost/directive[2]/arg = "www.alex.com"
*/
  /*
  <VirtualHost *:80>
  DocumentRoot "/www/alex/"
  ServerName www.alex.com
  </VirtualHost>
  */
  $virtual_host_changes = [
    "set VirtualHost/arg *:80",
    "set VirtualHost/directive[1] DocumentRoot",
    "set VirtualHost/directive[1]/arg ${document_root}",
    "set VirtualHost/directive[2] ServerName",
    "set VirtualHost/directive[2]/arg ${server_name}",
  ]
  augeas { "${server_name}.conf VirtualHost setup":
    incl    => "/etc/httpd/sites-available/${server_name}.conf",
    lens    => "Httpd.lns",
    context => "/files/etc/httpd/sites-available/${server_name}.conf/",
    changes => $virtual_host_changes,
    onlyif  => "match /files/etc/httpd/sites-available/${server_name}.conf/VirtualHost/directive[. = 'ServerName']/arg[. = '${server_name}'] size == 0",
    require => File["${server_name}.conf"]
  }

#  file {"enable ${server_name}.conf":
#    ensure => link,
#    source => "/etc/httpd/sites-available/${server_name}.conf",
#    target => "/etc/httpd/sites-enabled/${server_name}.conf",
##    notify => Service["httpd"],
#  }
}
