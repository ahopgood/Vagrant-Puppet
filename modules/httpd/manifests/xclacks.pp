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
      unless => "/bin/ls -l /etc/apache2/mods-enabled/ | /bin/grep headers",
      require => Package["apache2"],
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
  } elsif ("${operatingsystem}" == "CentOS"){
    if ("${$operatingsystemmajrelease}" == "6") {
      notify{"Beginning support for CentOS6":}
      #Find if the module is installed
      #apachectl -t -D DUMP_MODULES | grep headers
      
      exec {"module_source_exists":
        path => "/bin/",
        command => "ls -l /etc/httpd/modules/ | grep headers",
      }
      #For the following line:
      #LoadModule headers_module modules/mod_headers.so
      $module_load_contents = [
        "ins directive after /files/etc/httpd/conf/httpd.conf/directive[last()]",
        "set directive[last()] LoadModule",
        "set directive[last()]/arg[1] headers_module",
        "set directive[last()]/arg[2] modules/mod_headers.so",
      ]  
    
      augeas {"add header module to httpd config":
        incl => "/etc/httpd/conf/httpd.conf",
        lens => "Httpd.lns",
        context => "/files/etc/httpd/conf/httpd.conf/",
        changes => $module_load_contents,
        onlyif   => "match /files/etc/httpd/conf/httpd.conf/directive[. = 'LoadModule']/arg[. = 'headers_module'] size == 0",
        require => Exec["module_source_exists"],
      }
      ->
      exec {"restart-httpd-to-add-headers-module":
        path => "/sbin/:/bin/",
        command => "service httpd reload",
        unless => "/usr/sbin/apachectl -t -D DUMP_MODULES | /bin/grep headers",
      }
      
      
    
    }#close centos 6 check
    
    
    #Tells us if the module is installed, ideally want to know when it isn't install 
    #get /files/etc/httpd/conf/httpd.conf/directive[. = 'LoadModule']/arg[. != 'headers_module']
    
    #Match all headers_module
    #match /files/etc/httpd/conf/httpd.conf/directive[. = 'LoadModule']/arg[. == 'headers_module']
    #Match all non headers_module
    #match /files/etc/httpd/conf/httpd.conf/directive[. = 'LoadModule']/arg[. != 'headers_module']
    
    #match /files/etc/httpd/conf/httpd.conf/directive[. = 'LoadModule']/arg[1] != 'headers_module'
    #match directive[. = '/LoadModule'] size == 0


/**
 * /files/etc/httpd/conf/httpd.conf/directive[161] = "LoadModule"
/files/etc/httpd/conf/httpd.conf/directive[161]/arg[1] = "headers_module"
/files/etc/httpd/conf/httpd.conf/directive[161]/arg[2] = "modules/mod_headers.so"
 
 */
#    exec {"enable headers plugin": 
#      path => "/usr/sbin/:/usr/bin/",
#      command => "/usr/sbin/a2enmod headers",
#      unless => "/bin/ls -l /etc/apache2/mods-enabled/ | /bin/grep headers",
#      require => Package["apache2"],
#    }
#    ->
#    exec {"restart-apache2-to-install-headers":
#      path => "/usr/sbin/:/bin/",
#      command => "service apache2 restart",
#    }
#    
#    $header_contents = [
#    "set Directory[4]/arg '\"/var/www/html/\"'",
#    "set Directory[4]/directive[1] header",
#    "set Directory[4]/directive[1]/arg[1] set",
#    "set Directory[4]/directive[1]/arg[2] X-Clacks-Overhead",
#    "set Directory[4]/directive[1]/arg[3] '\"GNU Terry Pratchett\"'",
#    ]  
#    augeas {"add header to directory":
#      incl => "/etc/apache2/apache2.conf",
#      lens => "Httpd.lns",
#      context => "/files/etc/apache2/apache2.conf/",
#      changes => $header_contents,
#      require => Exec["restart-apache2-to-install-headers"]
#    }
#    ->
#    exec {"restart-apache2-to-add-x-clacks":
#      path => "/usr/sbin/:/bin/",
#      command => "service apache2 reload",
#    }
  } else {
    fail("${operatingsystem} is not currently supported")
  }
  
  
  
  #apache2ctl -M | grep headers
  #ls -l /etc/apache2/mods-enabled/ | grep headers
}