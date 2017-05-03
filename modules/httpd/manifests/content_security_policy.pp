define httpd::content_security_policy(
  $virtual_host = "global",
){
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

    if (versioncmp("${virtual_host}", "global") == 0){
      notify{"in global CSP":}

      $file_to_change = "/etc/apache2/apache2.conf"
      $context = "/files${file_to_change}/"
      $lens = "Httpd.lns"
      $csp_rule = "\"default-src \'self\'\""
      $contents = [
        "ins Directory after ${context}Directory[last()]",
        "set ${context}Directory[last()]/arg \"/var/www/html/\"",
        "set ${context}Directory[last()]/IfModule/arg headers_module",
        "set ${context}Directory[last()]/IfModule/directive[1] header",
        "set ${context}Directory[last()]/IfModule/directive[1]/arg[1] set",
        "set ${context}Directory[last()]/IfModule/directive[1]/arg[2] Content-Security-Policy",
        "set ${context}Directory[last()]/IfModule/directive[1]/arg[3] ${csp_rule}",
        "save",
        "print /augeas//error",
      ]
      $flattenedContents = $contents.reduce|$memo, $value| { "$memo \n$value" }
      file {"/home/vagrant/testfile.txt":
        content => $flattenedContents,
      }

      exec{"format quotes and single quotes for augtool":
        path => "/bin",
        command => "sed -f /vagrant/files/sed-script.txt -i /home/vagrant/testfile.txt",
        require => Class['augeas'],
      }

    exec{"apply header to main config file":
      path => "/usr/bin",
      command => "augtool -At \"${lens} incl ${file_to_change}\" -f /home/vagrant/testfile.txt",
      require => Exec["format quotes and single quotes for augtool"],
      #can we add an onlyif style clause here?
      #Only if the number of matching lines equals 0, i.e. only if we haven't put this header in before
      onlyif => "augtool -At \"Httpd.lns incl /etc/apache2/apache2.conf\" -f /vagrant/files/onlyif.txt | /bin/grep -c -v \"(no matches)\" | /usr/bin/awk '{ if (\$0 == 0) exit 0; else  exit 1; }'"
#      Equivalent to
#      $onlyif = "match /files${conf_file_location}/Directory[.]/IfModule[.]/directive[. = 'header']/arg[. = 'Content-Security-Policy'] size == 0"
    }


      $header_contents = [
      #global Directory level header
        "ins Directory after /files/etc/apache2/apache2.conf/Directory[last()]",
        "set Directory[last()]/arg '\"/var/www/html/\"'",
        "set Directory[last()]/IfModule/arg headers_module",
        "set Directory[last()]/IfModule/directive[1] header",
        "set Directory[last()]/IfModule/directive[1]/arg[1] set",
        "set Directory[last()]/IfModule/directive[1]/arg[2] Content-Security-Policy",
      ]
      $conf_file_location = "/etc/apache2/apache2.conf"

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