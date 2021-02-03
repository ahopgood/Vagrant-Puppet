class hiera::eyaml(
  $private_key_file = "",
  $public_key_file = "",
  $hiera_conf = "hiera.yaml",
  $puppet_home = "/etc/puppet/",
  $hiera_data = "/etc/puppet/hieradata/",
  $eyaml_keys = "/etc/puppet/hieradata/keys/",
) {

  #key files and hieradata/*.yaml files will need to be added together as a file is encrypted with a particular set of keys
  #potentially via shared folders?
  $puppet_file_dir = "modules/${module_name}/"
  $local_install_path = "/etc/puppet/"
  $local_install_dir = "${local_install_path}installers/"

  #install gems for eyaml, highline and trollop
  # Class["hiera::eyaml"] -> Class["hiera"]

  $hiera_eyaml_gem_file =  "hiera-eyaml-2.1.0.gem"
  file {"${hiera_eyaml_gem_file}":
    ensure => present,
    path => "${local_install_dir}${hiera_eyaml_gem_file}",
    source => "puppet:///${puppet_file_dir}${hiera_eyaml_gem_file}",
  }

  package { 'hiera_eyaml':
    source => "${local_install_dir}${hiera_eyaml_gem_file}",
    ensure   => 'installed',
    provider => 'gem',
    install_options => ["--force"],
    require => [
      File["${hiera_eyaml_gem_file}"],
      Package["highline"],
      Package["trollop"],
    ]
  }

  $highline_gem_file = "highline-1.7.10.gem"
  file {"${highline_gem_file}":
    ensure => present,
    path => "${local_install_dir}${highline_gem_file}",
    source => "puppet:///${puppet_file_dir}${highline_gem_file}",
  }

  package { 'highline':
    source => "${local_install_dir}${highline_gem_file}",
    ensure   => 'installed',
    provider => 'gem',
    require => File["${highline_gem_file}"],
  }

  $trollop_gem_file = "trollop-2.1.2.gem"
  file {"${trollop_gem_file}":
    ensure => present,
    path => "${local_install_dir}${trollop_gem_file}",
    source => "puppet:///${puppet_file_dir}${trollop_gem_file}",
  }

  package { 'trollop':
    source => "${local_install_dir}${trollop_gem_file}",
    ensure   => 'installed',
    provider => 'gem',
    require => File["${trollop_gem_file}"],
  }

  #Create keys directory
  #Set owner to puppet
  #Set group to puppet
  #Set directory permissions to 0400
  file {"${eyaml_keys}":
    ensure => directory,
    path => "${eyaml_keys}",
    owner => "puppet",
    group => "puppet",
    mode => "0400",
    require => File["${hiera_data}"]
  }

  #Set private_key.pkcs7.pem to 0500
  #Set public_key.pkcs7.pem to 0500
  file {"${private_key_file}":
    ensure => present,
    path => "${eyaml_keys}${private_key_file}",
    owner => "puppet",
    group => "puppet",
    mode => "0500",
    require => File["${eyaml_keys}"]
  }

  file {"${public_key_file}":
    ensure => present,
    path => "${eyaml_keys}${public_key_file}",
    owner => "puppet",
    group => "puppet",
    mode => "0500",
    require => File["${eyaml_keys}"]
  }

  if (versioncmp("${clientversion}", "5.0.0") == "-1") {
    notify{"We're on an old version of puppet [${clientversion}], we will use hiera 3 syntax for eyaml":}
    $versioned_location = "puppet/4/"
  } else {
    notify{"We're on puppet version greater than 5.0.0 [${clientversion}], we will use hiera 5 syntax for eyaml":}
    $versioned_location = "puppet/5/"
  }

  file {"${puppet_home}heira-eyaml.yaml":
    ensure => present,
    path => "${puppet_home}hiera-eyaml.yaml",
    content => template("${module_name}/${versioned_location}hiera-eyaml.yaml.erb"),
    # owner => "puppet",
    # group => "puppet",
    mode => "0777",
  }


  #Update hiera.yaml file with augeas to include:
  # ==== Sadly augeas cannot parse yaml files ====
  # :eyaml:
  #   :datadir: ${puppet_home}${hiera_data}
  #   # If using the pkcs7 encryptor (default)
  #   :pkcs7_private_key: ${eyaml_keys}private_key.pkcs7.pem
  #   :pkcs7_public_key:  ${eyaml_keys}public_key.pkcs7.pem
  #
  #   # Optionally cache decrypted data (default: false)
  #   :cache_decrypted: false

}