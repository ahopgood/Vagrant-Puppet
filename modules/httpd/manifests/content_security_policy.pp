define httpd::content_security_policy(
  $virtual_host = "global",
  $csp_rule = "\"\\\"default-src \'self\'\\\"\""
){
  $lens = "Httpd.lns"
  $header_name = "Content-Security-Policy"
  
  httpd::header::install{"CSP":
    before => Httpd::Header["CSP - IfModule"]
  }
  
  if (versioncmp("${virtual_host}", "global") == 0){
    notify{ "in ${virtual_host} CSP": }
    httpd::header::set_global{
      "CSP":
        header_name => "Content-Security-Policy",
        header_value => $csp_rule,
    }
  } else { #virtual host check
    notify{ "in ${virtual_host} CSP": }
    httpd::header::set{
      "CSP": 
      virtual_host => $virtual_host,
      header_name => "Content-Security-Policy",
      header_value => $csp_rule,
    }
  }# end global vs virtual host check
}