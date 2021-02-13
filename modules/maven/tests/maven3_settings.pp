$local_install_path = "/etc/puppet/"
$local_install_dir = "${local_install_path}installers/"

Package{
  allow_virtual => false,
}

$maven_major_version="3"
$maven_minor_version="5"
$maven_patch_version="2"

file{"${local_install_dir}":
  ensure => directory
}
->
java{"java-8":
  major_version => "8",
  update_version => "242",
  # isDefault => true,
}
->
class { 'maven':
  major_version => $maven_major_version,
  minor_version => $maven_minor_version,
  patch_version => $maven_patch_version,
}
->
class{"hiera":}
->
class{"hiera::eyaml":
  private_key_file => "private_key.pkcs7.pem",
  public_key_file => "public_key.pkcs7.pem",
}
->
maven::repository {"vagrant repository":
  user => "vagrant"
}
->
maven::repository::settings {"vagrant settings":
  user => "vagrant",
  password => hiera('maven::repository::settings::server::password',''),
  repository_name => "reclusive-repo",
  repository_address => "https://artifactory.alexanderhopgood.com/artifactory/reclusive-repo",
}
->
maven::repository::settings::security {"vagrant settings security":
  user => "vagrant",
  master_password => hiera('maven::repository::settings::security::master_password',''),
}

# sudo puppet apply --modulepath=/etc/puppet/modules/ --hiera_config=/etc/puppet/hiera-eyaml.yaml /vagrant/tests/maven3_settings.pp
