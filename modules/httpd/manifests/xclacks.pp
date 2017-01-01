define httpd::xclacks {
/*
  Using augeas we need to add the following to a .htaccess files
  <IfModule headers_module>
    header set X-Clacks-Overhead "GNU Terry Pratchett"
  </IfModule>

 We need to create a .htaccess file.
  
 After investigating .htaccess files a bit it seems they are frowned upon and are not enabled by default in apache versions 2.3.9 and later.
 Instead we should add the text to the httpd.conf file inside a Directory tag.
 <Directory "/var/www/html/">
  <IfModule headers_module>
    header set X-Clacks-Overhead "GNU Terry Pratchett"
  </IfModule>
 </Directory>

  We need to also enable the headers_module in apache by using a2enmod followed by the input headers
  sudo a2enmod --force headers
  This will prevent it asking for input
  This actually creates the following link in /etc/apache/mods-enabled/
  lrwxrwxrwx 1 root root 30 Dec 30 15:44 headers.load -> ../mods-available/headers.load
  Some plugins require a .conf file as well.
  Then we need to restart the apache service (varies based on os)

*/

#    notify{"Trying to set apache file":}
# set /files/etc/apache2/apache2.conf/Directory[3]/arg "/var/www/html"

  if ("${operatingsystem}" == "Ubuntu"){

    exec {"enable headers plugin": 
      path => "/usr/sbin/:/usr/bin/",
      command => "/usr/sbin/a2enmod headers",
#      returns => 13,
#      user => vagrant,
      unless => "/bin/ls -l /etc/apache2/mods-enabled/ | /bin/grep headers",
      require => Package["apache2"],
#      notify => Service["apache2"],
    }
    ->
    exec {"restart-apache2-to-install-headers":
      path => "/usr/sbin/:/bin/",
      command => "service apache2 restart",
    }
    
    $header_contents = [
    "set Directory[4]/arg '\"/var/www/html/\"'",
    "set Directory[4]/directive[1] header",
    "set Directory[4]/directive[1]/arg[1] set",
    "set Directory[4]/directive[1]/arg[2] X-Clacks-Overhead",
    "set Directory[4]/directive[1]/arg[3] '\"GNU Terry Pratchett\"'",
    ]  
    augeas {"add header to directory":
      incl => "/etc/apache2/apache2.conf",
      lens => "Httpd.lns",
      context => "/files/etc/apache2/apache2.conf/",
      changes => $header_contents,
      require => Exec["restart-apache2-to-install-headers"]
    }
    ->
    exec {"restart-apache2-to-add-x-clacks":
      path => "/usr/sbin/:/bin/",
      command => "service apache2 reload",
    }
    
  } else {
    fail("${operatingsystem} is not currently supported")
  }
  
  
  
  #apache2ctl -M | grep headers
  #ls -l /etc/apache2/mods-enabled/ | grep headers
}