$local_install_path = "/etc/puppet/"
$local_install_dir = "${local_install_path}installers/"

Package{
  allow_virtual => false,
}
file {
  "/etc/puppet/installers/":
    ensure     =>  directory,
}
$maven_major_version="2"
$maven_minor_version="0"
$maven_patch_version="5"

class { 'maven':
  major_version => $maven_major_version,
  minor_version => $maven_minor_version,
  patch_version => $maven_patch_version,
}