class pandoc{

  $local_install_path = "/etc/puppet/"
  $local_install_dir  = "${local_install_path}installers/"
  $puppet_file_dir    = "modules/pandoc/"

  if (versioncmp("${operatingsystem}", "Ubuntu") == 0){
    $pandoc_major_version = "2"
    $pandoc_minor_version = "1"
    $pandoc_patch_version = "1"
    $package_type = "deb"
    $pandoc_file_name = "pandoc-${pandoc_major_version}.${pandoc_minor_version}.${pandoc_patch_version}-1-${architecture}.${package_type}"
  } else {
    fail("${operatingsystem} is not currently supported")
  }

  notify{"${pandoc_file_name}":}
  file {"${pandoc_file_name}":
    ensure => present,
    path => "${local_install_dir}${pandoc_file_name}",
    source => ["puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${pandoc_file_name}"],
  }
}