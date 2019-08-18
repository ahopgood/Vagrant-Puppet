define httpd::headers::content_security_policy(
  $virtual_host = "global",
  $csp_rule = "\"\\\"default-src \'none\'\\\"\""
){
  $header_name = "Content-Security-Policy"
  httpd::header::add {
    "${header_name} ${virtual_host}":
      virtual_host => $virtual_host,
      header_name => $header_name,
      header_value => $csp_rule,
  }
}