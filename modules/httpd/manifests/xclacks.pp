define httpd::xclacks(
  $virtual_host = "global"
) {

  httpd::header::install{"x-clacks":}
  if (versioncmp("$virtual_host", "global") == 0){
    $header_value = "\"\\\"GNU Terry Pratchett\"\\\""
    httpd::header::set_global{
      "x-clacks":
        header_name => "X-Clacks-Overhead",
        header_value => $header_value,
    }
  } else {
    $header_value = "\"\\\"GNU Terry Pratchett\"\\\""
    httpd::header::set{
      "x-clacks":
        virtual_host => $virtual_host,
        header_name => "X-Clacks-Overhead",
        header_value => $header_value,
    }
  }
}