define httpd::headers::x_frame_options (
  $virtual_host = "global",
  $header_value = "sameorigin"
) {
  $header_name = "X-Frame-Options"
  httpd::header::add {
    "${header_name} ${virtual_host}":
      virtual_host => $virtual_host,
      header_name => $header_name,
      header_value => $header_value,
  }
}