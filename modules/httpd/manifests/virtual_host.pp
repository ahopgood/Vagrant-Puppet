define httpd::virtual_host(
  $server_name = undef,
  $document_root = undef,
  $server_alias = undef,
  $error_logs = false,
  $access_logs = false,
) {

  #Add error logs
  #Add custom logs
  contain 'httpd'

  if ($server_name == undef) {
    fail("A server_name is needed for creating a virtual host")
  }
  # if ($document_root == undef){
  #   fail("A document_root is needed for creating a virtual host")
  # }

  if (versioncmp("${operatingsystem}${operatingsystemmajrelease}", "CentOS7") == 0) {
    $httpd_conf_location = "/etc/httpd/conf/httpd.conf"
    $sites_available_location = "/etc/httpd/sites-available/"
    $sites_enabled_location = "/etc/httpd/sites-enabled/"
    $log_location = "/var/log/httpd/"
    $conf_file_name = "${server_name}"
    $httpd_package_name = "httpd"

    $httpd_major_version = "2"
    $httpd_minor_version = "4"
  } elsif (
    (versioncmp("${operatingsystem}${operatingsystemmajrelease}", "Ubuntu15.10") == 0)
    or
    (versioncmp("${operatingsystem}${operatingsystemmajrelease}", "Ubuntu16.04") == 0)){
    $httpd_conf_location = "/etc/apache2/apache2.conf"
    $sites_available_location = "/etc/apache2/sites-available/"
    $sites_enabled_location = "/etc/apache2/sites-enabled/"
    $log_location = "/var/log/apache2/"

    $conf_file_name = "${server_name}"
    $httpd_package_name = "apache2"

    $httpd_major_version = "2"
    $httpd_minor_version = "4"
  } elsif (versioncmp("${operatingsystem}${operatingsystemmajrelease}", "CentOS6") == 0) {
    $httpd_conf_location = "/etc/httpd/conf/httpd.conf"
    $sites_available_location = "/etc/httpd/conf/"
    $conf_file_name = "httpd"
    $httpd_package_name = "httpd"

    $httpd_major_version = "2"
    $httpd_minor_version = "2"
  } else {
    fail("${operatingsystem} ${operatingsystemmajrelease} not currently supported")
  }

  if (versioncmp("${httpd_major_version}.${httpd_minor_version}", "2.4") == 0) {
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
      mode    => "0777",
      require => [Augeas["load httpd.conf for ${name} virtual host"], Class["httpd::virtual_host::sites"]]
    }

    #Create the symbolic link from our *.conf in available to enabled.
    file { "enable ${conf_file_name}.conf":
      ensure  => link,
      target  => "${sites_available_location}${conf_file_name}.conf",
      path    => "${sites_enabled_location}${conf_file_name}.conf",
      before  => [
        Augeas["${server_name}.conf VirtualHost ServerName setup"]],
      require => File["${conf_file_name}.conf"]
    }

    $virtual_host_port_changes = [
      "set VirtualHost/arg *:80"
    ]
    #Add Document Root
    $virtual_host_document_root_changes = [
      "set VirtualHost/directive[last()+1] DocumentRoot",
      "set VirtualHost/directive[last()]/arg ${document_root}",
    ]
    #Add server name
    $virtual_host_server_name_changes = [
      "set VirtualHost/directive[last()+1] ServerName",
      "set VirtualHost/directive[last()]/arg ${server_name}",
    ]

    $virtual_host_access_logs_changes = [
      "set VirtualHost/directive[last()+1] CustomLog",
      "set VirtualHost/directive[last()]/arg[1] ${log_location}${server_name}-access.log",
      "set VirtualHost/directive[last()]/arg[2] combined",
    ]

    $virtual_host_error_logs_changes = [
      "set VirtualHost/directive[last()+1] ErrorLog",
      "set VirtualHost/directive[last()]/arg[1] ${log_location}${server_name}-error.log",
    ]

  } elsif (versioncmp("${httpd_major_version}.${httpd_minor_version}", "2.2") == 0) {
    $virtual_host_port_changes = [
      "set VirtualHost[last()+1]/arg *:80"
    ]
    #Add Document Root
    $virtual_host_document_root_changes = [
      "set VirtualHost[last()]/directive[last()+1] DocumentRoot",
      "set VirtualHost[last()]/directive[last()]/arg ${document_root}",
    ]
    #Add server name
    $virtual_host_server_name_changes = [
      "set VirtualHost[last()]/directive[last()+1] ServerName",
      "set VirtualHost[last()]/directive[last()]/arg ${server_name}",
    ]

    $virtual_host_access_logs_changes = [
      "set VirtualHost[last()]/directive[last()+1] CustomLog",
      "set VirtualHost[last()]/directive[last()]/arg[1] ${log_location}${server_name}-access.log",
      "set VirtualHost[last()]/directive[last()]/arg[2] combined",
    ]

    $virtual_host_error_logs_changes = [
      "set VirtualHost[last()]/directive[last()+1] ErrorLog",
      "set VirtualHost[last()]/directive[last()]/arg[1] ${log_location}${server_name}-error.log",
    ]

  } else {
    fail("${operatingsystem} ${operatingsystemmajrelease} not currently supported")
  }

  augeas { "${server_name}.conf VirtualHost port setup":
    incl    => "${sites_available_location}${conf_file_name}.conf",
    lens    => "Httpd.lns",
    context => "/files${sites_available_location}${conf_file_name}.conf/",
    changes => $virtual_host_port_changes,
    onlyif  => ["match /files${sites_available_location}${conf_file_name}.conf/VirtualHost/arg[. = '*:80'] size == 0"],
    require => Package["${httpd_package_name}"],
    before => Augeas["${server_name}.conf VirtualHost ServerName setup"]
  }
  if ($document_root != undef){
    #Add Document Root
    augeas { "${server_name}.conf VirtualHost DocumentRoot setup":
      incl    => "${sites_available_location}${conf_file_name}.conf",
      lens    => "Httpd.lns",
      context => "/files${sites_available_location}${conf_file_name}.conf/",
      changes => $virtual_host_document_root_changes,
      onlyif  => ["match /files${sites_available_location}${conf_file_name}.conf/VirtualHost[.]/directive[. = 'DocumentRoot']/arg[. = '${document_root}'] size == 0"],
      require => Package["${httpd_package_name}"],
      before => Augeas["${server_name}.conf VirtualHost ServerName setup"]
    }
  } else {
    augeas { "${server_name}.conf VirtualHost DocumentRoot removal":
      incl    => "${sites_available_location}${conf_file_name}.conf",
      lens    => "Httpd.lns",
      context => "/files${sites_available_location}${conf_file_name}.conf/",
      changes => "rm /files${sites_available_location}${conf_file_name}.conf/VirtualHost[.]/directive[. = 'DocumentRoot']",
      onlyif  => ["match /files${sites_available_location}${conf_file_name}.conf/VirtualHost[.]/directive[. = 'DocumentRoot'] size > 0"],
      before => Augeas["${server_name}.conf VirtualHost ServerName setup"],
      require => Package["${httpd_package_name}"],
    }
  }

  if ($access_logs == true){
    augeas { "${server_name}.conf VirtualHost Access Logs setup":
      incl    => "${sites_available_location}${conf_file_name}.conf",
      lens    => "Httpd.lns",
      context => "/files${sites_available_location}${conf_file_name}.conf/",
      changes => $virtual_host_access_logs_changes,
      onlyif  => ["match /files${sites_available_location}${conf_file_name}.conf/VirtualHost[.]/directive[. = 'CustomLog']/arg[. = '${log_location}${server_name}-access.log'] size == 0"],
      require => [Package["${httpd_package_name}"],
        Augeas["${server_name}.conf VirtualHost port setup"]],
      before => Augeas["${server_name}.conf VirtualHost ServerName setup"]
    }
  } else {
    augeas { "${server_name}.conf VirtualHost Access Logs removal":
      incl    => "${sites_available_location}${conf_file_name}.conf",
      lens    => "Httpd.lns",
      context => "/files${sites_available_location}${conf_file_name}.conf/",
      changes => "rm /files${sites_available_location}${conf_file_name}.conf/VirtualHost[.]/directive[. = 'CustomLog']",
      onlyif  => ["match /files${sites_available_location}${conf_file_name}.conf/VirtualHost[.]/directive[. = 'CustomLog'] size > 0"],
      require => [Package["${httpd_package_name}"]],
        # Augeas["${server_name}.conf VirtualHost ServerName setup"]],
      before => Augeas["${server_name}.conf VirtualHost ServerName setup"]
    }
  }
  if ($error_logs == true){
    augeas { "${server_name}.conf VirtualHost Error Logs setup":
      incl    => "${sites_available_location}${conf_file_name}.conf",
      lens    => "Httpd.lns",
      context => "/files${sites_available_location}${conf_file_name}.conf/",
      changes => $virtual_host_error_logs_changes,
      onlyif  => ["match /files${sites_available_location}${conf_file_name}.conf/VirtualHost[.]/directive[. = 'ErrorLog']/arg[. = '${log_location}${server_name}-error.log'] size == 0"],
      require => [Package["${httpd_package_name}"]],
        # Augeas["${server_name}.conf VirtualHost ServerName setup"]],
      before => Augeas["${server_name}.conf VirtualHost ServerName setup"]
    }
  } else {
    augeas { "${server_name}.conf VirtualHost Error Logs removal":
      incl    => "${sites_available_location}${conf_file_name}.conf",
      lens    => "Httpd.lns",
      context => "/files${sites_available_location}${conf_file_name}.conf/",
      changes => "rm /files${sites_available_location}${conf_file_name}.conf/VirtualHost[.]/directive[. = 'ErrorLog']",
      onlyif  => ["match /files${sites_available_location}${conf_file_name}.conf/VirtualHost[.]/directive[. = 'ErrorLog'] size > 0"],
      require => [Package["${httpd_package_name}"]],
        # Augeas["${server_name}.conf VirtualHost ServerName setup"]],
      before => Augeas["${server_name}.conf VirtualHost ServerName setup"]
    }
  }

  if ($server_alias != undef){
    each($server_alias) |$value|{
      httpd::virtual_host::server_alias{ "Server Alias ${value}":
        server_alias => $value,
        sites_available_location => $sites_available_location,
        sites_enabled_location => $sites_enabled_location,
        conf_file_name => $conf_file_name,
        server_name => $server_name,
        require => Augeas["${server_name}.conf VirtualHost ServerName setup"]
        # require => Augeas["${server_name}.conf VirtualHost DocumentRoot setup"],
        # before => Augeas["${server_name}.conf VirtualHost ServerName setup"]
      }
    }
  }
  #Add server name
  augeas { "${server_name}.conf VirtualHost ServerName setup":
    incl    => "${sites_available_location}${conf_file_name}.conf",
    lens    => "Httpd.lns",
    context => "/files${sites_available_location}${conf_file_name}.conf/",
    changes => $virtual_host_server_name_changes,
    onlyif  => "match /files${sites_available_location}${conf_file_name}.conf/VirtualHost[.]/directive[. = 'ServerName']/arg[. = '${server_name}'] size == 0",
    require => [
      Augeas["${server_name}.conf VirtualHost port setup"]
      ],
    notify => Service["${httpd_package_name}"]
  }
}

define httpd::virtual_host::server_alias(
  $server_alias,
  $sites_available_location,
  $sites_enabled_location,
  $conf_file_name,
  $server_name,
){
  if ("${server_alias}" == undef){
    notify{"No alias defined":}
  } else {
    #  notify{"in server alias ${alias}":}
    #Add server Alias name
    augeas { "${server_name}.conf VirtualHost ServerAlias ${server_alias} setup":
      incl    => "${sites_available_location}${conf_file_name}.conf",
      lens    => "Httpd.lns",
      context => "/files${sites_available_location}${conf_file_name}.conf/",
      changes => [
        "set VirtualHost[last()]/directive[last()+1] ServerAlias",
        "set VirtualHost[last()]/directive[last()]/arg ${server_alias}",
      ],
      onlyif  => "match /files${sites_available_location}${conf_file_name}.conf/VirtualHost[.]/directive[. = 'ServerAlias']/arg[. = '${server_alias}'] size == 0",
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
  } elsif ((versioncmp("${operatingsystem}${operatingsystemmajrelease}","Ubuntu15.10") == 0)
    or
    (versioncmp("${operatingsystem}${operatingsystemmajrelease}","Ubuntu16.04") == 0)){
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
      require => Package["${httpd_package_name}"]
#      require => Augeas["load httpd.conf for ${name} virtual host"],
    }

    #Create the /etc/httpd/sites-available/ directory
    file { "sites-available directory for ${name} virtual host":
      ensure  => directory,
      path    => "${sites_available_location}",
      require => Package["${httpd_package_name}"]
#      require => Augeas["load httpd.conf for ${name} virtual host"]
    }
  }
}

