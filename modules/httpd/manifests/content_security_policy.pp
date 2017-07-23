define httpd::content_security_policy(
  $virtual_host = "global",
  $csp_rule = "\"\\\"default-src \'self\'\\\"\""
){
  $lens = "Httpd.lns"
  $header_name = "Content-Security-Policy"
  
  httpd::header::install{"CSP ${name}":
    before => Httpd::Header["CSP ${name} - IfModule"]
  }
  
  if (versioncmp("${virtual_host}", "global") == 0){
    httpd::header::set_global{
      "CSP ${name}":
        header_name => $header_name,
        header_value => $csp_rule,
    }
  } else { #virtual host check
    httpd::header::set_virtual{
      "CSP ${name}": 
      virtual_host => $virtual_host,
      header_name => $header_name,
      header_value => $csp_rule,
    }
  }# end global vs virtual host check
}