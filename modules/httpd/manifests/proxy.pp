define httpd::proxy::install {

}

define httpd::proxy::gateway::install{
  # Enable:
  # proxy
  # proxy_http

  # Other modules might be required for other types of proxying
  # It might be worth setting this as a realised resource
  httpd::module::install{"install proxy module":
    module_name => "proxy",
  }
  ->
  httpd::module::install{"install proxy_http module":
    module_name => "proxy_http",
  }
}

define httpd::proxy::gateway::set_virtual(
  $virtual_host = undef,
  $host_address = undef,
  $required_origin_address = undef
) {
  if ($virtual_host == undef){
    fail("A virtual host is required when setting a gateway")
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
  $context = "/files/${conf_file_location}/"
    # <IfModule proxy_module>
    #   ProxyPreserveHost On
    #   ProxyPass "/" "http://192.168.4.5:8080/"
    #   ProxyPassReverse "/" "http://192.168.4.5:8080/"
    #   <Location "/">
    #     Require ip 192.168.0.0/16
    #   </Location>
    # </IfModule>
  # Might have to split these into individual augeas calls to allow for use of onlyif statements to be truly effective at preventing duplicates but allowing updates
  #Write up
  # include example of virtual host entry
  # virtual host parameter to find the correct virtual host file
  # destination ip to forward data to
  # location "/" to indicate that all root traffic on this virtual host will have the following restraints
  # Require ip parameter



  if ($host_address != undef){
    $proxy_contents = [
      "set VirtualHost/IfModule/arg proxy_module",
      "set VirtualHost/IfModule[arg = 'proxy_module']/directive[1] ProxyPreserveHost",
      "set VirtualHost/IfModule[arg = 'proxy_module']/directive[. = 'ProxyPreserveHost']/arg[1] Off",
      "set VirtualHost/IfModule[arg = 'proxy_module']/directive[2] ProxyPass",
      "set VirtualHost/IfModule[arg = 'proxy_module']/directive[. = 'ProxyPass']/arg[1] '\"/\"'",
      "set VirtualHost/IfModule[arg = 'proxy_module']/directive[. = 'ProxyPass']/arg[2] '\"${host_address}/\"'",
      "set VirtualHost/IfModule[arg = 'proxy_module']/directive[3] ProxyPassReverse",
      "set VirtualHost/IfModule[arg = 'proxy_module']/directive[. = 'ProxyPassReverse']/arg[1] '\"/\"'",
      "set VirtualHost/IfModule[arg = 'proxy_module']/directive[. = 'ProxyPassReverse']/arg[2] '\"${host_address}/\"'",
    ]

    augeas { "add proxy_module module to ${virtual_host} config":
      incl     => "${conf_file_location}",
      lens     => "Httpd.lns",
      context  => "${context}",
      changes  => $proxy_contents,
      onlyif   => "match ${context}/VirtualHost/IfModule/arg[. = 'proxy_module']/directive[. = 'ProxyPass']/arg[2] != '\"${host_address}\"'",
    }
  } else {
    augeas { "remove proxy_module module from ${virtual_host} config":
      incl     => "${conf_file_location}",
      lens     => "Httpd.lns",
      context  => "${context}",
      changes  => [
        "clear ${context}/VirtualHost/IfModule[arg = 'proxy_module']/",
        "rm ${context}/VirtualHost/IfModule[arg = 'proxy_module']/"
      ],
    }
  }
  if ( $required_origin_address != undef ){
    $location_contents = [
      "set VirtualHost/IfModule[arg = 'proxy_module']/Location/arg '\"/\"'",
      "set VirtualHost/IfModule[arg = 'proxy_module']/Location/directive Require",
      "set VirtualHost/IfModule[arg = 'proxy_module']/Location/directive[. = 'Require']/arg[1] ip",
      "set VirtualHost/IfModule[arg = 'proxy_module']/Location/directive[. = 'Require']/arg[2] ${required_origin_address}",
    ]
    augeas { "Adding Require Ip ${required_origin_address} to gateway":
      incl     => "${conf_file_location}",
      lens     => "Httpd.lns",
      context  => "${context}",
      changes  => $location_contents,
      onlyif   => "match ${context}/VirtualHost/IfModule/arg[. = 'proxy_module']/Location/directive[. = 'Require']/arg[2] != '${required_origin_address}'",
      require =>  Augeas["add proxy_module module to ${virtual_host} config"]
    }
  } else {
    # remove the location required ip entry
    augeas { "Removing Require Ip from gateway":
      incl     => "${conf_file_location}",
      lens     => "Httpd.lns",
      context  => "${context}",
      changes  => [
        "clear ${context}/VirtualHost/IfModule[arg = 'proxy_module']/Location/",
        "rm ${context}/VirtualHost/IfModule[arg = 'proxy_module']/Location/"
      ],
    }
  }

}