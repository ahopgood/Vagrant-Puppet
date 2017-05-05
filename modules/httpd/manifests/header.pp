define httpd::header(
  $conf_file_location = "/etc/apache2/apache2.conf",
  $context = "/files${conf_file_location}/",
  $lens = "Httpd.lns",
  $header_contents = undef, # array
){
  if ("$name" == undef){
    fail("You need to set a name for this header to allow for individually named puppet resources to be used.")
  }

  $flattenedHeaderContents = $header_contents.reduce|$memo, $value| { "$memo \n$value" }

  $header_contents_file = "/home/vagrant/testfile-${name}.txt"
  file {"${header_contents_file}":
    content => $flattenedHeaderContents,
  }

  $onlyif = "match /files/etc/apache2/apache2.conf/Directory[.]/IfModule[.]/directive[. = 'header']/arg[. = 'Content-Security-Policy']"
  $onlyif_file = "/home/vagrant/onlyif-${name}.txt"
  file {"${onlyif_file}":
    content => "${onlyif}"
  }

  $augtool_location = "/usr/bin"
  exec{"apply header [${name}] to main config file":
    path => "${augtool_location}",
    command => "augtool -At \"${lens} incl ${conf_file_location}\" -f ${header_contents_file}",
    require => [
      #          Exec["reformat quotes and single quotes for augtool"],
      File["${onlyif_file}"],
      File["${header_contents_file}"],
    ],
    #        onlyif => "${augtool_location}/augtool -At \"${lens} incl ${conf_file_location}\" -f ${onlyif_file} | /bin/grep -c -v \"(no matches)\" | /usr/bin/awk '{ if (\$0 == 0) exit 0; else  exit 1; }'",
  }
  ->
  exec {"restart-apache2-to-add-csp for header ${name}":
    path => "/usr/sbin/:/bin/",
    command => "service apache2 reload",
  }
}