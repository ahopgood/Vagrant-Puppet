define httpd::headers::x_content_type_options (
  $virtual_host = "global",
  $header_value = "nosniff"
) {
  $header_name = "X-Content-Type-Options"
  httpd::header::add {
    "${header_name} ${virtual_host}":
      virtual_host => $virtual_host,
      header_name => $header_name,
      header_value => $header_value,
  }
}