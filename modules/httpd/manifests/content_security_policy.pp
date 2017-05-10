define httpd::content_security_policy(
  $virtual_host = "global",
){
  if ("${operatingsystem}" == "Ubuntu"){
    exec {"enable headers plugin":
      path => "/usr/sbin/:/usr/bin/",
      command => "/usr/sbin/a2enmod headers",
      unless => "/bin/ls -l /etc/apache2/mods-enabled/ | /bin/grep headers",
      require => [Package["apache2"],Class["httpd"]]
    }
    ->
    exec {"restart-apache2-to-install-headers":
      path => "/usr/sbin/:/bin/",
      command => "service apache2 restart",
    }

    if (versioncmp("${virtual_host}", "global") == 0){
      notify{"in global CSP":}

      $conf_file_location = "/etc/apache2/apache2.conf"
      $context = "/files${conf_file_location}/"
      $lens = "Httpd.lns"
      $csp_rule = "\"\\\"default-src \'self\'\\\"\""

      #insert first onlyif match not present
      #insert everything else if 
      $directory_header_contents = [
#        "set ${context}Directory[arg = '\"/var/www/html/\"]/arg \\\"/var/www/html/\\\"",
#        "set ${context}Directory[arg = '\"/var/www/html/\"']/IfModule/arg headers_module",
#        "set ${context}Directory[arg = '\"/var/www/html/\"']/IfModule/directive[arg = 'Content-Security-Policy'] header",
#        "set ${context}Directory[arg = '\"/var/www/html/\"']/IfModule/directive[1]/arg[1] set",
#        "set ${context}Directory[arg = '\"/var/www/html/\"']/IfModule/directive[1]/arg[2] Content-Security-Policy",
#        "set ${context}Directory[arg = '\"/var/www/html/\"']/IfModule/directive[1]/arg[3] ${csp_rule}",
#        "ins Directory after ${context}Directory[last()]",
        "set ${context}Directory[last()+1]/arg \\\"/var/www/html/\\\"",
        "save",
        "print /augeas//error"
      ]
      #if there's no match - this isn't working
      $directory_onlyif = "match /files/etc/apache2/apache2.conf/Directory[arg = '\"/var/www/html/\"']"
      httpd::header{ "CSP - directory":
        conf_file_location => $conf_file_location,
        context => $context,
        lens => $lens,
        header_contents => $directory_header_contents,
        onlyif => $directory_onlyif,
        before => [
          Httpd::Header["CSP - header"],
          Httpd::Header["CSP - IfModule"],
          Exec["restart-apache2-to-add-csp for header ${name}"],
        ]
      }
      $header_contents = [
        "set ${context}Directory[arg = '\"/var/www/html/\"']/IfModule/arg headers_module",
        "save",
        "print /augeas//error"
      ]
      $header_onlyif = "match /files/etc/apache2/apache2.conf/Directory[arg = '\"/var/www/html/\"']/IfModule[arg = 'headers_module']"

      httpd::header{ "CSP - IfModule":
        conf_file_location => $conf_file_location,
        context => $context,
        lens => $lens,
        header_contents => $header_contents,
        onlyif => $header_onlyif,
        before => [
          Httpd::Header["CSP - header"],
          Httpd::Header["CSP - contents"],
          Exec["restart-apache2-to-add-csp for header ${name}"],
        ]
      }
      
      $csp_header = [  
        "set ${context}Directory[arg = '\"/var/www/html/\"']/IfModule[arg = 'headers_module']/directive[last()+1] header",
        "set ${context}Directory[arg = '\"/var/www/html/\"']/IfModule[arg = 'headers_module']/directive[last()]/arg[1] set",
        "set ${context}Directory[arg = '\"/var/www/html/\"']/IfModule[arg = 'headers_module']/directive[last()]/arg[2] Content-Security-Policy",
        "save",
        "print /augeas//error",
      ]
      $onlyif = "match /files/etc/apache2/apache2.conf/Directory[arg = '\"/var/www/html/\"']/IfModule[arg = 'headers_module']/directive[. = 'header' and arg = 'Content-Security-Policy']"
      httpd::header{ "CSP - header":
        conf_file_location => $conf_file_location,
        context => $context,
        lens => $lens,
        header_contents => $csp_header,
        onlyif => $onlyif,
        before => [
          Httpd::Header["CSP - contents"],
          Exec["restart-apache2-to-add-csp for header ${name}"],
        ]
      }

      $csp_header_contents = [
        "set ${context}Directory[arg = '\"/var/www/html/\"']/IfModule[arg = 'headers_module']/directive[. = 'header' and arg = 'Content-Security-Policy']/arg[3] ${csp_rule}",
        "save",
        "print /augeas//error",
      ]
#      $onlyif = "match /files/etc/apache2/apache2.conf/Directory[arg = '\"/var/www/html/\"']/IfModule[arg = 'headers_module']/directive[. = 'header' and arg = 'Content-Security-Policy' and arg = 'dummy']"
      httpd::header{ "CSP - contents":
        conf_file_location => $conf_file_location,
        context => $context,
        lens => $lens,
        header_contents => $csp_header_contents,
#        onlyif => $onlyif,
        before => [
          Exec["restart-apache2-to-add-csp for header ${name}"],
#          Httpd::Header["CSP - header"],
        ]
      }
#
      ->
      exec {"restart-apache2-to-add-csp for header ${name}":
        path => "/usr/sbin/:/bin/",
        command => "service apache2 reload",
      }
      ##    #Need to set if we find the correct node, and ins if we don't
#      
#      exec{"apply header to main config file":
#        path => "${augtool_location}",
#        command => "augtool -At \"${lens} incl ${conf_file_location}\" -f ${header_contents_file}",
#        require => [
##          Exec["reformat quotes and single quotes for augtool"],
#          File["${onlyif_file}"],
#          File["${header_contents_file}"],
#        ],
##        onlyif => "${augtool_location}/augtool -At \"${lens} incl ${conf_file_location}\" -f ${onlyif_file} | /bin/grep -c -v \"(no matches)\" | /usr/bin/awk '{ if (\$0 == 0) exit 0; else  exit 1; }'",
#      }
#      ->
#      exec {"restart-apache2-to-add-csp":
#        path => "/usr/sbin/:/bin/",
#        command => "service apache2 reload",
#      }
      #can we add an onlyif style clause here?
      #Only if the number of matching lines equals 0, i.e. only if we haven't put this header in before
      #      Equivalent to augeas puppet provider
      #      $onlyif = "match /files${conf_file_location}/Directory[.]/IfModule[.]/directive[. = 'header']/arg[. = 'Content-Security-Policy'] size == 0"

    } else {
      notify{"in ${server_name} CSP":}
      $header_contents = [
        #Want to match the VirtualHost entry where the <ServerName "www.alexander.com"> 
        #/files/etc/apache2/sites-available/www.alexander.com.conf/VirtualHost[*]/directive[. = 'ServerName' and arg = 'www.alexander.com']
        #/files/etc/apache2/sites-available/www.alexander.com.conf/VirtualHost[directive = 'ServerName' and directive/arg = 'www.alexander.com']/IfModule/arg headers_module
        "set VirtualHost[directive = 'ServerName' and directive/arg = '${server_name}']/IfModule/arg headers_module",
        "set VirtualHost[directive = 'ServerName' and directive/arg = '${server_name}']/IfModule/arg headers_module",
        "set VirtualHost[directive = 'ServerName' and directive/arg = '${server_name}']/IfModule/directive[1] header",
        "set VirtualHost[directive = 'ServerName' and directive/arg = '${server_name}']/IfModule/directive[1]/arg[1] set",
        "set VirtualHost[directive = 'ServerName' and directive/arg = '${server_name}']/IfModule/directive[1]/arg[2] Content-Security-Policy",
        "set VirtualHost[directive = 'ServerName' and directive/arg = '${server_name}']/IfModule/directive[1]/arg[3]'\"default-src 'self';\"'"
      ]
      $conf_file_location = "/etc/apache2/sites-available/${server_name}.conf"
      $onlyif = "match /files${conf_file_location}/VirtualHost[directive = 'ServerName' and directive/arg = '${server_name}']/IfModule[.]/directive[. = 'header']/arg[. = 'Content-Security-Policy'] size == 0"
    }

#    augeas {"add header to directory":
#      incl => "${conf_file_location}",
#      lens => "Httpd.lns",
#      context => "/files${conf_file_location}/",
#      changes => $header_contents,
#      require => Exec["restart-apache2-to-install-headers"],
#      onlyif   => "${onlyif}"
##Need to change this to allow for updating of the CSP value but not adding duplicates
#    }
#    ->
#    exec {"restart-apache2-to-add-csp":
#      path => "/usr/sbin/:/bin/",
#      command => "service apache2 reload",
#    }
  } elsif ("${operatingsystem}" == "CentOS"){
    if ("${operatingsystemmajrelease}" == "6" or "${operatingsystemmajrelease}" == "7") {
      notify{"Beginning support for CentOS${operatingsystemmajrelease}":}
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
        before => Augeas["add header to directory"],
      }

      #module check
      #<IfModule mod_headers.c>

      $header_contents = [
        "ins IfModule after /files/etc/httpd/conf/httpd.conf/IfModule[last()]",
        "set IfModule[last()]/arg mod_headers.c",
        "set IfModule[last()]/Directory/arg '\"/var/www/html/\"'",
        "set IfModule[last()]/Directory/directive[1] header",
        "set IfModule[last()]/Directory/directive[1]/arg[1] set",
        "set IfModule[last()]/Directory/directive[1]/arg[2] X-Clacks-Overhead",
        "set IfModule[last()]/Directory/directive[1]/arg[3] '\"GNU Terry Pratchett\"'",
      ]
      augeas {"add header to directory":
        incl => "/etc/httpd/conf/httpd.conf",
        lens => "Httpd.lns",
        context => "/files/etc/httpd/conf/httpd.conf/",
        changes => $header_contents,
        onlyif   => "match /files/etc/httpd/conf/httpd.conf/Directory[.]/directive[. = 'header']/arg[. = 'X-Clacks-Overhead'] size == 0",
      }
      ->
      exec {"restart-httpd-to-add-x-clacks":
        path => "/sbin/:/bin/",
        command => "service httpd reload",
      }
      #close centos 6 & 7 check
    }
    #Tells us if the module is installed, ideally want to know when it isn't install 
    #get /files/etc/httpd/conf/httpd.conf/directive[. = 'LoadModule']/arg[. != 'headers_module']

    #Match all headers_module
    #match /files/etc/httpd/conf/httpd.conf/directive[. = 'LoadModule']/arg[. == 'headers_module']
    #Match all non headers_module
    #match /files/etc/httpd/conf/httpd.conf/directive[. = 'LoadModule']/arg[. != 'headers_module']

    #match /files/etc/httpd/conf/httpd.conf/directive[. = 'LoadModule']/arg[1] != 'headers_module'
    #match directive[. = '/LoadModule'] size == 0



  } else {
    fail("${operatingsystem} is not currently supported")
  }
}