define httpd::header(
  $conf_file_location = "/etc/apache2/apache2.conf",
  $context = "/files${conf_file_location}/",
  $lens = "Httpd.lns",
  $header_contents = undef, # array
  $onlyif = undef,
){
  if ("$name" == undef){
    fail("You need to set a name for this header to allow for individually named puppet resources to be used.")
  }
  $augtool_location = "/usr/bin"
  $flattenedHeaderContents = $header_contents.reduce|$memo, $value| { "$memo \n$value" }

  $header_contents_file = "/home/vagrant/testfile-${name}.txt"
  file {"${header_contents_file}":
    content => $flattenedHeaderContents,
  }

  #$onlyif = "match /files/etc/apache2/apache2.conf/Directory[.]/IfModule[.]/directive[. = 'header']/arg[. = 'Content-Security-Policy']"
  if ($onlyif != undef){
    $onlyif_file = "/home/vagrant/onlyif-${name}.txt"
    file {"${onlyif_file}":
      content => "${onlyif}",
      before => Exec["apply header [${name}] to main config file"],
    }
    $onlyif_exec = "${augtool_location}/augtool -At \"${lens} incl ${conf_file_location}\" -f \"${onlyif_file}\" | /bin/grep -c -v \"(no matches)\" | /usr/bin/awk '{ if (\$0 == 0) exit 0; else  exit 1; }'"
  } else {
    $onlyif_exec = "/bin/echo"
  }
  
  exec{"apply header [${name}] to main config file":
    path => "${augtool_location}",
    command => "augtool -At \"${lens} incl ${conf_file_location}\" -f \"${header_contents_file}\"",
    require => [
      File["${header_contents_file}"],
      Class["augeas"],
    ],
    onlyif => $onlyif_exec
  }

}