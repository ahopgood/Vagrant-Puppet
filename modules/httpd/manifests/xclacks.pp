define httpd::xclacks(
  $virtual_host = "global"
) {

  $header_value = "\"\\\"GNU Terry Pratchett\"\\\""
  $header_name = "X-Clacks-Overhead"
  httpd::header::install{"x-clacks ${name}":}
  
  if (versioncmp("$virtual_host", "global") == 0){
    httpd::header::set_global{
      "x-clacks ${name}":
        header_name => $header_name,
        header_value => $header_value,
    }
  } else {
    httpd::header::set_virtual{
      "x-clacks ${name}":
        virtual_host => $virtual_host,
        header_name => $header_name,
        header_value => $header_value,
    }
  }
}