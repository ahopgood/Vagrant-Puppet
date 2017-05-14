define httpd::content_security_policy(
  $virtual_host = "global",
){
  $csp_rule = "\"\\\"default-src \'self\'\\\"\""
  $lens = "Httpd.lns"
  if ("${operatingsystem}" == "Ubuntu"){
    exec { "enable headers plugin":
      path    => "/usr/sbin/:/usr/bin/",
      command => "/usr/sbin/a2enmod headers",
      unless  => "/bin/ls -l /etc/apache2/mods-enabled/ | /bin/grep headers",
      require => [Package["apache2"],Class["httpd"]]
    }
    ->
    exec { "restart-apache2-to-install-headers":
      path    => "/usr/sbin/:/bin/",
      command => "service apache2 restart",
    }
  } elsif (versioncmp("${operatingsystem}", "CentOS") == 0){
    if ("${operatingsystemmajrelease}" == "6" or "${operatingsystemmajrelease}" == "7") {
      #      notify{"Beginning support for CentOS${operatingsystemmajrelease}":}
      #Find if the module is installed
      #apachectl -t -D DUMP_MODULES | grep headers

      exec { "module_source_exists [${name}]":
        path    => "/bin/",
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

      augeas { "add header module to httpd config":
        incl     => "/etc/httpd/conf/httpd.conf",
        lens     => "Httpd.lns",
        context  => "/files/etc/httpd/conf/httpd.conf/",
        changes  => $module_load_contents,
        onlyif   => "match /files/etc/httpd/conf/httpd.conf/directive[. = 'LoadModule']/arg[. = 'headers_module'] size == 0",
        require  => Exec["module_source_exists [${name}]"],
      }
      ->
      exec { "restart-httpd-to-add-headers-module":
        path    => "/sbin/:/bin/",
        command => "service httpd reload",
        unless  => "/usr/sbin/apachectl -t -D DUMP_MODULES | /bin/grep headers",
        #        before => Augeas["add header to directory"],
      }
    }
  } else {
    fail("${operatingsystem} is not currently supported")
  }
  if (versioncmp("${virtual_host}", "global") == 0){
    if (versioncmp("${operatingsystem}", "Ubuntu") == 0){
      notify{"in global CSP":}
      $conf_file_location = "/etc/apache2/apache2.conf"
      $context = "/files${conf_file_location}/"
      $virtual_host_name = "/var/www/"
      $virtual_host_name_search_term = "\"${virtual_host_name}\""

      $directory_header_contents = [
        "set ${context}Directory[last()+1]/arg \\\"${virtual_host_name}\\\"",
        "save",
        "print /augeas//error"
      ]
      #if there's no match - this isn't working
      $directory_onlyif = "match ${context}Directory[arg = '$virtual_host_name_search_term']"
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
        "set ${context}Directory[arg = '$virtual_host_name_search_term']/IfModule/arg headers_module",
        "save",
        "print /augeas//error"
      ]
      $header_onlyif = "match ${context}Directory[arg = '$virtual_host_name_search_term']/IfModule[arg = 'headers_module']"

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
        "set ${context}Directory[arg = '$virtual_host_name_search_term']/IfModule[arg = 'headers_module']/directive[last()+1] header",
        "set ${context}Directory[arg = '$virtual_host_name_search_term']/IfModule[arg = 'headers_module']/directive[last()]/arg[1] set",
        "set ${context}Directory[arg = '$virtual_host_name_search_term']/IfModule[arg = 'headers_module']/directive[last()]/arg[2] Content-Security-Policy",
        "save",
        "print /augeas//error",
      ]
      $onlyif = "match ${context}Directory[arg = '$virtual_host_name_search_term']/IfModule[arg = 'headers_module']/directive[. = 'header' and arg = 'Content-Security-Policy']"
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
        "set ${context}Directory[arg = '$virtual_host_name_search_term']/IfModule[arg = 'headers_module']/directive[. = 'header' and arg = 'Content-Security-Policy']/arg[3] ${csp_rule}",
        "save",
        "print /augeas//error",
      ]
      httpd::header{ "CSP - contents":
        conf_file_location => $conf_file_location,
        context => $context,
        lens => $lens,
        header_contents => $csp_header_contents,
        before => [
          Exec["restart-apache2-to-add-csp for header ${name}"],
        ]
      }
      ->
      exec {"restart-apache2-to-add-csp for header ${name}":
        path => "/usr/sbin/:/bin/",
        command => "service apache2 reload",
      }
      #Only if the number of matching lines equals 0, i.e. only if we haven't put this header in before
      #      Equivalent to augeas puppet provider
      #      $onlyif = "match /files${conf_file_location}/Directory[.]/IfModule[.]/directive[. = 'header']/arg[. = 'Content-Security-Policy'] size == 0"
    } elsif ("${operatingsystem}" == "CentOS"){
      $conf_file_location = "/etc/httpd/conf/httpd.conf"
      $context = "/files${conf_file_location}/"

      $virtual_host_name = "/var/www/"
      $virtual_host_name_search_term = "\"${virtual_host_name}\""

      $header_ifModule = [
        "set ${context}IfModule[last()+1]/arg mod_headers.c",
        "save",
        "print /augeas//error"
      ]
      #Onlyif is failing
      $header_ifModule_onlyif = "match ${context}IfModule[arg = 'mod_headers.c']"

      httpd::header{ "CSP - IfModule":
        conf_file_location => $conf_file_location,
        context => $context,
        lens => $lens,
        header_contents => $header_ifModule,
        onlyif => $header_ifModule_onlyif,
        before => [
          Httpd::Header["CSP - directory"],
          Exec["restart-httpd-to-add-header for ${name}"],
        ]
      }

      $directory_header_contents = [
        "set ${context}IfModule[arg = 'mod_headers.c']/Directory/arg \\\"${virtual_host_name}\\\"",
        "save",
        "print /augeas//error"
      ]
      $directory_onlyif = "match ${context}IfModule[arg = 'mod_headers.c']/Directory[arg = '$virtual_host_name_search_term']"
      httpd::header{ "CSP - directory":
        conf_file_location => $conf_file_location,
        context => $context,
        lens => $lens,
        header_contents => $directory_header_contents,
        onlyif => $directory_onlyif,
        before => [
          Httpd::Header["CSP - header"],
          Exec["restart-httpd-to-add-header for ${name}"],
        ]
      }
      $csp_header = [
        "set ${context}IfModule[arg = 'mod_headers.c']/Directory[arg = '$virtual_host_name_search_term']/directive[last()+1] header",
        "set ${context}IfModule[arg = 'mod_headers.c']/Directory[arg = '$virtual_host_name_search_term']/directive[last()]/arg[1] set",
        "set ${context}IfModule[arg = 'mod_headers.c']/Directory[arg = '$virtual_host_name_search_term']/directive[last()]/arg[2] Content-Security-Policy",
        "save",
        "print /augeas//error",
      ]
      $onlyif = "match ${context}IfModule[arg = 'mod_headers.c']/Directory[arg = '$virtual_host_name_search_term']/directive[. = 'header' and arg = 'Content-Security-Policy']"
      httpd::header{ "CSP - header":
        conf_file_location => $conf_file_location,
        context => $context,
        lens => $lens,
        header_contents => $csp_header,
        onlyif => $onlyif,
        before => [
          Httpd::Header["CSP - contents"],
          Exec["restart-httpd-to-add-header for ${name}"],
        ]
      }

      $csp_header_contents = [
        "set ${context}IfModule[arg = 'mod_headers.c']/Directory[arg = '$virtual_host_name_search_term']/directive[. = 'header' and arg = 'Content-Security-Policy']/arg[3] ${csp_rule}",
        "save",
        "print /augeas//error",
      ]
      httpd::header{ "CSP - contents":
        conf_file_location => $conf_file_location,
        context => $context,
        lens => $lens,
        header_contents => $csp_header_contents,
        before => [
          Exec["restart-httpd-to-add-header for ${name}"],
        ]
      }

      exec {"restart-httpd-to-add-header for ${name}":
        path => "/sbin/:/bin/",
        command => "service httpd reload",
        require => [
          Exec["restart-httpd-to-add-headers-module"],
        ]
      }
    }# end version check
  } else { #virtual host check
    notify{ "in ${server_name} CSP": }
    if (versioncmp("${operatingsystem}", "Ubuntu") == 0){
      $conf_file_location = "/etc/apache2/sites-available/${virtual_host}.conf"
    } elsif (versioncmp ("${operatingsystem}", "CentOS") == 0){
      $conf_file_location = "/etc/httpd/sites-available/${virtual_host}.conf"
    }
    $context = "/files${conf_file_location}/"
    $virtual_host_name = "${virtual_host}"
    $virtual_host_name_search_term = "\"${virtual_host_name}\""

    $directory_header_contents = [
      "set ${context}VirtualHost/IfModule/arg headers_module",
      "save",
      "print /augeas//error"
    ]
    #if there's no match - this isn't working
    $directory_onlyif = "match ${context}VirtualHost/IfModule[arg = 'headers_module']"
    httpd::header{ "CSP - IfModule":
      conf_file_location => $conf_file_location,
      context            => $context,
      lens               => $lens,
      header_contents    => $directory_header_contents,
      onlyif             => $directory_onlyif,
      before             => [
        Httpd::Header["CSP - header"],
        Exec["restart-apache2-to-add-csp for header ${name}"],
      ]
    }
    $header_contents = [
      "set ${context}VirtualHost/IfModule[arg = 'headers_module']/directive header",
      "set ${context}VirtualHost/IfModule[arg = 'headers_module']/directive[. = 'header']/arg[1] set",
      "set ${context}VirtualHost/IfModule[arg = 'headers_module']/directive[. = 'header']/arg[2] Content-Security-Policy",
      "save",
      "print /augeas//error"
    ]
    $header_onlyif = "match ${context}VirtualHost/IfModule[arg = 'headers_module']/directive[. = 'header' and arg = 'Content-Security-Policy']"

    httpd::header{ "CSP - header":
      conf_file_location => $conf_file_location,
      context            => $context,
      lens               => $lens,
      header_contents    => $header_contents,
      onlyif             => $header_onlyif,
      before             => [
        #          Httpd::Header["CSP - header"],
        Httpd::Header["CSP - contents"],
        #          Httpd::Header["CSP - IfModule"],
        Exec["restart-apache2-to-add-csp for header ${name}"],
      ]
    }

    $csp_header_contents = [
      "set ${context}VirtualHost/IfModule[arg = 'headers_module']/directive[. = 'header' and arg = 'Content-Security-Policy']/arg[3] ${csp_rule}",
      "save",
      "print /augeas//error",
    ]
    httpd::header{ "CSP - contents":
      conf_file_location => $conf_file_location,
      context            => $context,
      lens               => $lens,
      header_contents    => $csp_header_contents,
      before             => [
        Exec["restart-apache2-to-add-csp for header ${name}"],
      ]
    }

    if (versioncmp("${operatingsystem}", "Ubuntu") == 0){
      exec { "restart-apache2-to-add-csp for header ${name}":
        path    => "/usr/sbin/:/bin/",
        command => "service apache2 reload",
      }
    } elsif (versioncmp("${operatingsystem}", "CentOS") == 0){
      #        exec {"restart-httpd-to-add-header for ${name}":
      exec { "restart-apache2-to-add-header for ${name}":
        path    => "/sbin/:/bin/",
        command => "service httpd reload",
        require => [
          Exec["restart-httpd-to-add-headers-module"],
        ]
      }
    } else {
      fail("Operating System: [${operatingsystem}] not supported")
    }
  }
}