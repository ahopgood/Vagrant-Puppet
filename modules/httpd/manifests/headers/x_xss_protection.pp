define httpd::headers::x_xss_protection (
  $virtual_host = "global",
  $header_value = "1; mode=block"
) {
  $header_name = "X-XSS-Protection"
  httpd::header::add {
    "${header_name} ${virtual_host}":
      virtual_host => $virtual_host,
      header_name => $header_name,
      header_value => $header_value,
  }
}