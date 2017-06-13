define httpd::virtual_host(
  $server_name = undef,
  $document_root = undef,
  $server_alias = undef,
){

  #Add error logs
  #Add custom logs
  #Add server alias
  #Add server admin

  contain 'httpd'

  if ("${server_name}" == undef){
    fail("A server_name is needed for creating a virtual host")
  }
  if ("${document_root}" == undef){
    fail("A document_root is needed for creating a virtual host")
  }

  if (versioncmp("${operatingsystem}${operatingsystemmajrelease}","CentOS7") == 0) {
    $httpd_conf_location = "/etc/httpd/conf/httpd.conf"
    $sites_available_location = "/etc/httpd/sites-available/"
    $sites_enabled_location = "/etc/httpd/sites-enabled/"
    $conf_file_name = "${server_name}"
    $httpd_package_name = "httpd"

    $httpd_major_version = "2"
    $httpd_minor_version = "4"
  } elsif (versioncmp("${operatingsystem}${operatingsystemmajrelease}","Ubuntu15.10") == 0) {
    $httpd_conf_location = "/etc/apache2/apache2.conf"
    $sites_available_location = "/etc/apache2/sites-available/"
    $sites_enabled_location = "/etc/apache2/sites-enabled/"

    $conf_file_name = "${server_name}"
    $httpd_package_name = "apache2"

    $httpd_major_version = "2"
    $httpd_minor_version = "4"
  } elsif (versioncmp("${operatingsystem}${operatingsystemmajrelease}","CentOS6") == 0) {
    $httpd_conf_location = "/etc/httpd/conf/httpd.conf"
    $sites_available_location = "/etc/httpd/conf/"
    $conf_file_name = "httpd"
    $httpd_package_name = "httpd"

    $httpd_major_version = "2"
    $httpd_minor_version = "2"
  } else {
    fail("${operatingsystem} ${operatingsystemmajrelease} not currently supported")
  }

  if (versioncmp("${httpd_major_version}.${httpd_minor_version}","2.4") == 0) {
      #Using apache 2.4.x
      #Use augeas to add the following to the /etc/httpd/conf/httpd.conf file if not present
      #IncludeOptional sites-enabled/*.conf
      $host_changes = [
        "set directive[last()+1] IncludeOptional",
        "set directive[last()]/arg[1] sites-enabled/*.conf",
      ]
      augeas { "load httpd.conf for ${name} virtual host":
        incl    => "${httpd_conf_location}",
        lens    => "Httpd.lns",
        context => "/files${httpd_conf_location}/",
        changes => $host_changes,
        onlyif  => "match /files${httpd_conf_location}/directive[. = 'IncludeOptional']/arg[. = 'sites-enabled/*.conf'] size == 0",
        require => Package["${httpd_package_name}"]
      }
    
      file { "${conf_file_name}.conf":
        ensure  => present,
        path    => "${sites_available_location}${conf_file_name}.conf",
        mode    => 0777,
        require => [Augeas["load httpd.conf for ${name} virtual host"],Class["httpd::virtual_host::sites"]]
      }

      #Create the symbolic link form our *.conf in available to enabled.
      file { "enable ${conf_file_name}.conf":
        ensure  => link,
        target  => "${sites_available_location}${conf_file_name}.conf",
        path    => "${sites_enabled_location}${conf_file_name}.conf",
        before  => [Augeas["${server_name}.conf VirtualHost DocumentRoot setup"], Augeas["${server_name}.conf VirtualHost ServerName setup"]],
        require => File["${conf_file_name}.conf"]
      }
    
      #Add Document Root
      $virtual_host_document_root_changes = [
        "set VirtualHost/arg *:80",
        "set VirtualHost/directive[last()+1] DocumentRoot",
        "set VirtualHost/directive[last()]/arg ${document_root}",
      ]
      #Add server name
      $virtual_host_server_name_changes = [
        "set VirtualHost/directive[last()+1] ServerName",
        "set VirtualHost/directive[last()]/arg ${server_name}",
      ]
    } elsif (versioncmp("${httpd_major_version}.${httpd_minor_version}","2.2") == 0) {
      #Add Document Root
      $virtual_host_document_root_changes = [
        "set VirtualHost[last()+1]/arg *:80",
        "set VirtualHost[last()]/directive[last()+1] DocumentRoot",
        "set VirtualHost[last()]/directive[last()]/arg ${document_root}",
      ]
      #Add server name
      $virtual_host_server_name_changes = [
        "set VirtualHost[last()]/directive[last()+1] ServerName",
        "set VirtualHost[last()]/directive[last()]/arg ${server_name}",
      ]
    } else {
      fail("${operatingsystem} ${operatingsystemmajrelease} not currently supported")
    }

    #Add Document Root
    augeas { "${server_name}.conf VirtualHost DocumentRoot setup":
      incl    => "${sites_available_location}${conf_file_name}.conf",
      lens    => "Httpd.lns",
      context => "/files${sites_available_location}${conf_file_name}.conf/",
      changes => $virtual_host_document_root_changes,
      onlyif  => ["match /files${sites_available_location}${conf_file_name}.conf/VirtualHost[.]/directive[. = 'DocumentRoot']/arg[. = '${document_root}'] size == 0"],
      before => Augeas["${server_name}.conf VirtualHost ServerName setup"],
      require => Package["${httpd_package_name}"]
    }
->
  httpd::virtual_host::server_alias{$server_alias:
    sites_available_location => $sites_available_location,
    sites_enabled_location => $sites_enabled_location,
    conf_file_name => $conf_file_name,
    server_name => $server_name,
    before => Augeas["${server_name}.conf VirtualHost ServerName setup"]
  }
->
  #Add server name
    augeas { "${server_name}.conf VirtualHost ServerName setup":
      incl    => "${sites_available_location}${conf_file_name}.conf",
      lens    => "Httpd.lns",
      context => "/files${sites_available_location}${conf_file_name}.conf/",
      changes => $virtual_host_server_name_changes,
      onlyif  => "match /files${sites_available_location}${conf_file_name}.conf/VirtualHost[.]/directive[. = 'ServerName']/arg[. = '${server_name}'] size == 0",
      notify => Service["${httpd_package_name}"]
    }
}

define httpd::virtual_host::server_alias($alias = $title,
  $sites_available_location,
  $sites_enabled_location,
  $conf_file_name,
  $server_name,
){
  if ("${alias}" == undef){
    notify{"No alias defined":}
  } else {
    #  notify{"in server alias ${alias}":}
    #Add server Alias name
    augeas { "${server_name}.conf VirtualHost ServerAlias  ${alias} setup":
      incl    => "${sites_available_location}${conf_file_name}.conf",
      lens    => "Httpd.lns",
      context => "/files${sites_available_location}${conf_file_name}.conf/",
      changes => [
        "set VirtualHost[last()]/directive[last()+1] ServerAlias",
        "set VirtualHost[last()]/directive[last()]/arg ${alias}",
      ],
      onlyif  => "match /files${sites_available_location}${conf_file_name}.conf/VirtualHost[.]/directive[. = 'ServerAlias']/arg[. = '${alias}'] size == 0",
      #   notify => Service["${httpd_package_name}"]
    }
  }
}

class httpd::virtual_host::sites(){
  if (versioncmp("${operatingsystem}${operatingsystemmajrelease}","CentOS7") == 0) {
    $httpd_conf_location = "/etc/httpd/conf/httpd.conf"
    $sites_available_location = "/etc/httpd/sites-available/"
    $sites_enabled_location = "/etc/httpd/sites-enabled/"
    $conf_file_name = "${server_name}"
    $httpd_package_name = "httpd"

    $httpd_major_version = "2"
    $httpd_minor_version = "4"
  } elsif (versioncmp("${operatingsystem}${operatingsystemmajrelease}","Ubuntu15.10") == 0) {
    $httpd_conf_location = "/etc/apache2/apache2.conf"
    $sites_available_location = "/etc/apache2/sites-available/"
    $sites_enabled_location = "/etc/apache2/sites-enabled/"

    $conf_file_name = "${server_name}"
    $httpd_package_name = "apache2"

    $httpd_major_version = "2"
    $httpd_minor_version = "4"
  } elsif (versioncmp("${operatingsystem}${operatingsystemmajrelease}","CentOS6") == 0) {
    $httpd_conf_location = "/etc/httpd/conf/httpd.conf"
    $sites_available_location = "/etc/httpd/conf/"
    $conf_file_name = "httpd"
    $httpd_package_name = "httpd"

    $httpd_major_version = "2"
    $httpd_minor_version = "2"
  } else {
    fail("${operatingsystem} ${operatingsystemmajrelease} not currently supported")
  }
  
  if (versioncmp("${httpd_major_version}.${httpd_minor_version}","2.4") == 0) {
    #Create the /etc/httpd/sites-enabled/ directory
    file { "sites-enabled directory for ${name} virtual host":
      ensure  => directory,
      path    => "${sites_enabled_location}",
#      require => Augeas["load httpd.conf for ${name} virtual host"],
    }

    #Create the /etc/httpd/sites-available/ directory
    file { "sites-available directory for ${name} virtual host":
      ensure  => directory,
      path    => "${sites_available_location}",
#      require => Augeas["load httpd.conf for ${name} virtual host"]
    }
  }
}

