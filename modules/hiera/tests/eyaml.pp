# Package{
#   allow_virtual => false
# }

$local_install_path = "/etc/puppet/"
$local_install_dir = "${local_install_path}installers/"
file {
  "${local_install_dir}":
    ensure => directory,
}


class{"hiera":}
->
class{"hiera::eyaml":
  private_key_file => "private_key.pkcs7.pem",
  public_key_file => "public_key.pkcs7.pem",
}


$value = hiera('jenkins::gitCredentials::git_hub_api_token','test')

notify {"git token ${value}":
  require => Class['hiera::eyaml']
}