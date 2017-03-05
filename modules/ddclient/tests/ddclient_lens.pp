
  Package{
    allow_virtual => false
  }

  $local_install_path = "/etc/puppet/"
  $local_install_dir = "${local_install_path}installers/"
  $puppet_file_dir = "modules/ddclient/"

  file {
    "${local_install_dir}":
      path       =>  "${local_install_dir}",
      ensure     =>  directory,
  }

  class {"augeas":}
  ->
  class{"ddclient":}
  #Install augtools
  #Link /vagrant/files/test_ddclientconf.aug
  #To
  #/usr/share/augeas/lenses/tests/test_ddclientconf.aug
  #    ensure => present,
  #    source => "puppet:///${puppet_file_dir}test_ddclientconf.aug",

  file { "/usr/share/augeas/lenses/tests/":
    ensure => directory,
    mode => 0777,
  }
  
  file {"/usr/share/augeas/lenses/tests/test_ddclientconf.aug":
    ensure => "link",
    target => "/vagrant/files/test_ddclientconf.aug",
    require => File["/usr/share/augeas/lenses/tests/"]
  }
  #Run lens test
#  augparse /usr/share/augeas/lenses/tests/test_ddclientconf.aug

    file {"/usr/share/augeas/lenses/DDClientConf.lns":
    ensure => "link",
    target => "/vagrant/files/DDClientConf.lns",
    require => File["/usr/share/augeas/lenses/tests/test_ddclientconf.aug"]
  }
