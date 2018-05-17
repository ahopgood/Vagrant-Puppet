define httpd::module::install(
  $module_name = undef
){
  if ("${operatingsystem}" == "Ubuntu"){
    exec { "enable ${module_name} plugin":
      path    => "/usr/sbin/:/usr/bin/",
      command => "/usr/sbin/a2enmod ${module_name}",
      unless  => "/bin/ls -l /etc/apache2/mods-enabled/ | /bin/grep ${module_name}",
      require => [Package["apache2"],Class["httpd"]]
    }
    ->
    exec { "restart-apache2-to-install-${module_name}":
      path    => "/usr/sbin/:/bin/",
      command => "service apache2 restart",
      unless  => "/bin/ls -l /etc/apache2/mods-enabled/ | /bin/grep ${module_name}",
    }
  } elsif (versioncmp("${operatingsystem}", "CentOS") == 0){
    if (
      (versioncmp("${operatingsystemmajrelease}", "6") == 0)
        or
        (versioncmp("${operatingsystemmajrelease}", "7") == 0)) {
      #      notify{"Beginning support for CentOS${operatingsystemmajrelease}":}
      #Find if the module is installed
      #apachectl -t -D DUMP_MODULES | grep headers

      exec { "module_source_exists ${module_name}":
        path    => "/bin/",
        command => "ls -l /etc/httpd/modules/ | grep ${module_name}",
      }
      #For the following line:
      #LoadModule headers_module modules/mod_headers.so
      $module_load_contents = [
        "ins directive after /files/etc/httpd/conf/httpd.conf/directive[last()]",
        "set directive[last()] LoadModule",
        "set directive[last()]/arg[1] ${module_name}_module",
        "set directive[last()]/arg[2] modules/mod_${module_name}.so",
      ]

      augeas { "add ${module_name} module to httpd config":
        incl     => "/etc/httpd/conf/httpd.conf",
        lens     => "Httpd.lns",
        context  => "/files/etc/httpd/conf/httpd.conf/",
        changes  => $module_load_contents,
        onlyif   => "match /files/etc/httpd/conf/httpd.conf/directive[. = 'LoadModule']/arg[. = '${module_name}_module'] size == 0",
        require  => Exec["module_source_exists [${name}]"],
      }
      ->
      exec { "restart-httpd-to-add-${module_name}-module":
        path    => "/sbin/:/bin/",
        command => "service httpd reload",
        unless  => "/usr/sbin/apachectl -t -D DUMP_MODULES | /bin/grep ${module_name}",
      }
    } else {
      fail("${operatingsystem} ${operatingsystemmajrelease} is not currently supported")
    }
  } else {
    fail("${operatingsystem} is not currently supported")
  }
}