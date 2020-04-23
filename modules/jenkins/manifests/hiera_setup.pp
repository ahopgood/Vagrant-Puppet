$local_install_path = "/etc/puppet/"
$local_install_dir = "${local_install_path}installers/"
Package{
  allow_virtual => false,
}
file {
  "/etc/puppet/installers/":
    ensure     =>  directory,
}
->
class{"hiera":}
->
class{"hiera::eyaml":
  private_key_file => "private_key.pkcs7.pem",
  public_key_file => "public_key.pkcs7.pem",
}