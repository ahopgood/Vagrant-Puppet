define httpd::headers::xclacks (
  $virtual_host = "global"
) {
  $header_value = "\"\\\"GNU Terry Pratchett\"\\\""
  $header_name = "X-Clacks-Overhead"
  httpd::header::add {
    "${header_name} ${virtual_host}":
      virtual_host => $virtual_host,
      header_name => $header_name,
      header_value => $header_value,
  }
}