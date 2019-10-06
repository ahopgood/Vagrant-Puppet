class certbot {

  $puppet_file_dir = "modules/certbot/"
  $local_install_path = "/etc/puppet/"
  $local_install_dir = "${local_install_path}installers/"

  if (versioncmp("${operatingsystem}", "Ubuntu") == 0) {
    if (versioncmp("${operatingsystemmajrelease}", "18.04") == 0) {
      certbot::ubuntu::bionic{"test":}
    } else {
      fail("${operatingsystem} ${operatingsystemmajrelease} not supported.")
    }
  } else {
    fail("${operatingsystem} not supported.")
  }
}
define certbot::apache {

  if (versioncmp("${operatingsystem}", "Ubuntu") == 0) {
    if (versioncmp("${operatingsystemmajrelease}", "18.04") == 0) {
      Certbot::Ubuntu::Bionic::Apache{"test":}
    } else {
      fail("${operatingsystem} ${operatingsystemmajrelease} not supported.")
    }
  } else {
    fail("${operatingsystem} not supported.")
  }
}