define httpd::cross_origin_resource_sharing(
  $virtual_host = "global"
){
  $lens = "Httpd.lns"
  $header_name = "Access-Control-Allow-Origin"
  $header_value = "\\\"*\\\""

  httpd::header::install{"CORS ${name}":
    before => Httpd::Header["CORS ${name} - IfModule"]
  }

  if (versioncmp("${virtual_host}", "global") == 0){
    httpd::header::set_global{
      "CORS ${name}":
        header_name => $header_name,
        header_value => $header_value,
    }
  } else { #virtual host check
    httpd::header::set_virtual{
      "CORS ${name}":
        virtual_host => $virtual_host,
        header_name => $header_name,
        header_value => $header_value,
    }
  }# end global vs virtual host check
}