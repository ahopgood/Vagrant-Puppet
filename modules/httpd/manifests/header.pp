define httpd::header(
  $conf_file_location = "/etc/apache2/apache2.conf",
  $context = "/files${conf_file_location}/",
  $lens = "Httpd.lns",
  $header_contents = undef, # array
  $onlyif = undef,
){
  if ("$name" == undef){
    fail("You need to set a name for this header to allow for individually named puppet resources to be used.")
  }
  $augtool_location = "/usr/bin"
  $flattenedHeaderContents = $header_contents.reduce|$memo, $value| { "$memo \n$value" }

  $header_contents_file = "/home/vagrant/testfile-${name}.txt"
  file { "${header_contents_file}":
    content => $flattenedHeaderContents,
  }

  #$onlyif = "match /files/etc/apache2/apache2.conf/Directory[.]/IfModule[.]/directive[. = 'header']/arg[. = 'Content-Security-Policy']"
  if ($onlyif != undef){
    $onlyif_file = "/home/vagrant/onlyif-${name}.txt"
    file { "${onlyif_file}":
      content => "${onlyif}",
      before  => Exec["apply header [${name}] to main config file"],
    }
    $onlyif_exec = "${augtool_location}/augtool -At \"${lens} incl ${conf_file_location}\" -f \"${onlyif_file}\" | /bin/grep -c -v \"(no matches)\" | /usr/bin/awk '{ if (\$0 == 0) exit 0; else  exit 1; }'"
  } else {
    $onlyif_exec = "/bin/echo"
  }

  exec{ "apply header [${name}] to main config file":
    path    => "${augtool_location}",
    command => "augtool -At \"${lens} incl ${conf_file_location}\" -f \"${header_contents_file}\"",
    require => [
      File["${header_contents_file}"],
      Class["augeas"],
    ],
    onlyif  => $onlyif_exec
  }
}

define httpd::header::install{
  if ("${operatingsystem}" == "Ubuntu"){
    exec { "enable headers plugin [${name}]":
      path    => "/usr/sbin/:/usr/bin/",
      command => "/usr/sbin/a2enmod headers",
      unless  => "/bin/ls -l /etc/apache2/mods-enabled/ | /bin/grep headers",
      require => [Package["apache2"],Class["httpd"]],
    }

    exec { "restart-apache2-to-install-headers [${name}]":
      path    => "/usr/sbin/:/bin/",
      command => "service apache2 restart",
      unless  => "/bin/ls -l /etc/apache2/mods-enabled/ | /bin/grep headers",
      require => Exec["enable headers plugin [${name}]"],
    }
  } elsif (versioncmp("${operatingsystem}", "CentOS") == 0){
    if (
      (versioncmp("${operatingsystemmajrelease}", "6") == 0) 
      or 
      (versioncmp("${operatingsystemmajrelease}", "7") == 0)) {
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

      augeas { "add header module to httpd config [${name}]":
        incl     => "/etc/httpd/conf/httpd.conf",
        lens     => "Httpd.lns",
        context  => "/files/etc/httpd/conf/httpd.conf/",
        changes  => $module_load_contents,
        onlyif   => "match /files/etc/httpd/conf/httpd.conf/directive[. = 'LoadModule']/arg[. = 'headers_module'] size == 0",
        require  => Exec["module_source_exists [${name}]"],
      }
      ->
      exec { "restart-httpd-to-add-headers-module [${name}]":
        path    => "/sbin/:/bin/",
        command => "service httpd reload",
        unless  => "/usr/sbin/apachectl -t -D DUMP_MODULES | /bin/grep headers",
        require => Augeas["add header module to httpd config [${name}]"]
      }
    } else {
      fail("${operatingsystem} ${operatingsystemmajrelease} is not currently supported")
    }
  } else {
    fail("${operatingsystem} is not currently supported")
  }
}

/*
 * Sets a header within a specified virtual host file.
 */
define httpd::header::set_virtual(
  $virtual_host = undef,
  $header_name = undef,
  $header_value = undef,
) {
  $lens = "Httpd.lns"
  if ($header_name == undef){
    fail("A header type is required to set a header")
  }
  if ($header_value == undef){
    fail("Header contents are required when setting a header")
  }
  if ($virtual_host == undef){
    fail("A virtual host is required when setting a header")
  }
  if (versioncmp("${operatingsystem}", "Ubuntu") == 0){
    $conf_file_location = "/etc/apache2/sites-available/${virtual_host}.conf"
  } elsif (versioncmp ("${operatingsystem}", "CentOS") == 0){
    if (versioncmp ("${operatingsystemmajrelease}", "6") == 0){
      $conf_file_location = "/etc/httpd/conf/httpd.conf"
    } else {
      $conf_file_location = "/etc/httpd/sites-available/${virtual_host}.conf"
    }
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
  httpd::header{ "${name} - IfModule":
    conf_file_location => $conf_file_location,
    context            => $context,
    lens               => $lens,
    header_contents    => $directory_header_contents,
    onlyif             => $directory_onlyif,
    before             => [
      Httpd::Header["${name} - header"],
      Exec["restart-apache2-to-add ${name} header"],
    ]
  }
  $header_contents = [
    "set ${context}VirtualHost/IfModule[arg = 'headers_module']/directive[last()+1] header",
    "set ${context}VirtualHost/IfModule[arg = 'headers_module']/directive[last()][. = 'header']/arg[1] set",
    "set ${context}VirtualHost/IfModule[arg = 'headers_module']/directive[last()][. = 'header']/arg[2] ${header_name}",
    "save",
    "print /augeas//error"
  ]
  $header_onlyif = "match ${context}VirtualHost/IfModule[arg = 'headers_module']/directive[. = 'header' and arg = '${header_name}']"

  httpd::header{ "${name} - header":
    conf_file_location => $conf_file_location,
    context            => $context,
    lens               => $lens,
    header_contents    => $header_contents,
    onlyif             => $header_onlyif,
    before             => [
      Httpd::Header["${name} - contents"],
      Exec["restart-apache2-to-add ${name} header"],
    ]
  }

  $csp_header_contents = [
    "set ${context}VirtualHost/IfModule[arg = 'headers_module']/directive[. = 'header' and arg = '${header_name}']/arg[3] ${header_value}",
    "save",
    "print /augeas//error",
  ]
  httpd::header{ "${name} - contents":
    conf_file_location => $conf_file_location,
    context            => $context,
    lens               => $lens,
    header_contents    => $csp_header_contents,
    before             => [
      Exec["restart-apache2-to-add ${name} header"],
    ]
  }

  if (versioncmp("${operatingsystem}", "Ubuntu") == 0){
    exec { "restart-apache2-to-add ${name} header":
      path    => "/usr/sbin/:/bin/",
      command => "service apache2 reload",
      require =>[
        Httpd::Header::Install["${name}"],
      ]
    }
  } elsif (versioncmp("${operatingsystem}", "CentOS") == 0){
    #        exec {"restart-httpd-to-add-header for ${name}":
    exec { "restart-apache2-to-add ${name} header":
      path    => "/sbin/:/bin/",
      command => "service httpd reload",
      require => [
        Httpd::Header::Install["${name}"],
      ]
    }
  } else {
    fail("Operating System: [${operatingsystem}] not supported")
  }
}

/*
 * Sets a header in the global apache configuration
 */
define httpd::header::set_global(
  $header_name = undef,
  $header_value = undef,
) {
  $lens = "Httpd.lns"
  if (versioncmp("${operatingsystem}", "Ubuntu") == 0){
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
    httpd::header{ "${name} - directory":
      conf_file_location => $conf_file_location,
      context => $context,
      lens => $lens,
      header_contents => $directory_header_contents,
      onlyif => $directory_onlyif,
      before => [
        Httpd::Header["${name} - header"],
        Httpd::Header["${name} - IfModule"],
        Exec["restart-apache2-to-add-csp for header ${name}"],
      ]
    }
    $header_contents = [
      "set ${context}Directory[arg = '$virtual_host_name_search_term']/IfModule/arg headers_module",
      "save",
      "print /augeas//error"
    ]
    $header_onlyif = "match ${context}Directory[arg = '$virtual_host_name_search_term']/IfModule[arg = 'headers_module']"

    httpd::header{ "${name} - IfModule":
      conf_file_location => $conf_file_location,
      context => $context,
      lens => $lens,
      header_contents => $header_contents,
      onlyif => $header_onlyif,
      before => [
        Httpd::Header["${name} - header"],
        Httpd::Header["${name} - contents"],
        Exec["restart-apache2-to-add-csp for header ${name}"],
      ]
    }

    $csp_header = [
      "set ${context}Directory[arg = '$virtual_host_name_search_term']/IfModule[arg = 'headers_module']/directive[last()+1] header",
      "set ${context}Directory[arg = '$virtual_host_name_search_term']/IfModule[arg = 'headers_module']/directive[last()]/arg[1] set",
      "set ${context}Directory[arg = '$virtual_host_name_search_term']/IfModule[arg = 'headers_module']/directive[last()]/arg[2] ${header_name}",
      "save",
      "print /augeas//error",
    ]
    $onlyif = "match ${context}Directory[arg = '$virtual_host_name_search_term']/IfModule[arg = 'headers_module']/directive[. = 'header' and arg = '${header_name}']"
    httpd::header{ "${name} - header":
      conf_file_location => $conf_file_location,
      context => $context,
      lens => $lens,
      header_contents => $csp_header,
      onlyif => $onlyif,
      before => [
        Httpd::Header["${name} - contents"],
        Exec["restart-apache2-to-add-csp for header ${name}"],
      ]
    }

    $csp_header_contents = [
      "set ${context}Directory[arg = '$virtual_host_name_search_term']/IfModule[arg = 'headers_module']/directive[. = 'header' and arg = '${header_name}']/arg[3] ${header_value}",
      "save",
      "print /augeas//error",
    ]
    httpd::header{ "${name} - contents":
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

    httpd::header{ "${name} - IfModule":
      conf_file_location => $conf_file_location,
      context => $context,
      lens => $lens,
      header_contents => $header_ifModule,
      onlyif => $header_ifModule_onlyif,
      before => [
        Httpd::Header["${name} - directory"],
        Exec["restart-httpd-to-add-header for ${name}"],
      ]
    }

    $directory_header_contents = [
      "set ${context}IfModule[arg = 'mod_headers.c']/Directory[last()+1]/arg \\\"${virtual_host_name}\\\"",
      "save",
      "print /augeas//error"
    ]
    $directory_onlyif = "match ${context}IfModule[arg = 'mod_headers.c']/Directory[arg = '$virtual_host_name_search_term']"
    httpd::header{ "${name} - directory":
      conf_file_location => $conf_file_location,
      context => $context,
      lens => $lens,
      header_contents => $directory_header_contents,
      onlyif => $directory_onlyif,
      before => [
        Httpd::Header["${name} - header"],
        Exec["restart-httpd-to-add-header for ${name}"],
      ]
    }
    $csp_header = [
      "set ${context}IfModule[arg = 'mod_headers.c']/Directory[arg = '$virtual_host_name_search_term']/directive[last()+1] header",
      "set ${context}IfModule[arg = 'mod_headers.c']/Directory[arg = '$virtual_host_name_search_term']/directive[last()]/arg[1] set",
      "set ${context}IfModule[arg = 'mod_headers.c']/Directory[arg = '$virtual_host_name_search_term']/directive[last()]/arg[2] ${header_name}",
      "save",
      "print /augeas//error",
    ]
    $onlyif = "match ${context}IfModule[arg = 'mod_headers.c']/Directory[arg = '$virtual_host_name_search_term']/directive[. = 'header' and arg = '${header_name}']"
    httpd::header{ "${name} - header":
      conf_file_location => $conf_file_location,
      context => $context,
      lens => $lens,
      header_contents => $csp_header,
      onlyif => $onlyif,
      before => [
        Httpd::Header["${name} - contents"],
        Exec["restart-httpd-to-add-header for ${name}"],
      ]
    }

    $csp_header_contents = [
      "set ${context}IfModule[arg = 'mod_headers.c']/Directory[arg = '$virtual_host_name_search_term']/directive[. = 'header' and arg = '${header_name}']/arg[3] ${header_value}",
      "save",
      "print /augeas//error",
    ]
    httpd::header{ "${name} - contents":
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
        Httpd::Header::Install["${name}"],
      ]
    }
  }# end version check
}

define httpd::header::add(
  $virtual_host = "global",
  $header_name = undef,
  $header_value = undef,
) {
  httpd::header::install{"${name}":}

  if (versioncmp("$virtual_host", "global") == 0){
    httpd::header::set_global{
      "${name}":
        header_name => $header_name,
        header_value => $header_value,
    }
  } else {
    httpd::header::set_virtual{
      "${name}":
        virtual_host => $virtual_host,
        header_name => $header_name,
        header_value => $header_value,
    }
  }
}