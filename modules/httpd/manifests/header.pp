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
      require => [Package["apache2"],Class["httpd"]]
    }
    ->
    exec { "restart-apache2-to-install-headers [${name}]":
      path    => "/usr/sbin/:/bin/",
      command => "service apache2 restart",
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
      }
    } else {
      fail("${operatingsystem} ${operatingsystemmajrelease} is not currently supported")
    }
  } else {
    fail("${operatingsystem} is not currently supported")
  }
}