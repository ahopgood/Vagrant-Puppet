class vagrant (
  $password = "\$6\$CmPxLmdO\$b6snWEx607JHLIadKcFva1NLuT1eyI6bxcSGmYjV8NassgJCp4RB5ADPS8ihmJRl1yxALJ3S0gd0YmjcZnq4t/",
  $public_key = "AAAAB3NzaC1yc2EAAAADAQABAAABAQC5R//cU9cXY0tb/NOGUrFcmWyZh5PMOi+kgaWj26KAtPYt9SQ6PTOY8gxvrhpXnW0n6kSev4aQosUlqqySrz+H9H/VQ29p0bIK5E65K9CeQTZHWOscsiVE7OQB/tsiscgWycsR9TsFfgUwmaKHsSxL2LAmh+yU2OgSKZypYXMUaj2n1N+whljqD65Ni20KHoLog2s3UXbDr0h84oUbhUiPbgvAAEYbyolmli0lB5yTAyWPwCBlobEJH6rnXfCC7o4dmIYCxkxfhqc1vivmKpelYgVgWgep/72LZibN6w9+QYRuAvF3kcfgNR1cZEEZ/ZDaX/7/QhZTX7ewsNp3tyrP"
){
  user {
    "vagrant":
      password => "${password}",
      # password => "\$6\$CmPxLmdO\$b6snWEx607JHLIadKcFva1NLuT1eyI6bxcSGmYjV8NassgJCp4RB5ADPS8ihmJRl1yxALJ3S0gd0YmjcZnq4t/",
  }
  ->
  ssh_authorized_key { 'vagrant insecure public key':
    ensure => absent,
    user   => 'vagrant',
    type   => 'ssh-rsa',
  }
  ->
  ssh_authorized_key { 'vagrant secure public key':
    ensure => present,
    user   => 'vagrant',
    type   => 'ssh-rsa',
    # key    => 'AAAAB3NzaC1yc2EAAAADAQABAAABAQC5R//cU9cXY0tb/NOGUrFcmWyZh5PMOi+kgaWj26KAtPYt9SQ6PTOY8gxvrhpXnW0n6kSev4aQosUlqqySrz+H9H/VQ29p0bIK5E65K9CeQTZHWOscsiVE7OQB/tsiscgWycsR9TsFfgUwmaKHsSxL2LAmh+yU2OgSKZypYXMUaj2n1N+whljqD65Ni20KHoLog2s3UXbDr0h84oUbhUiPbgvAAEYbyolmli0lB5yTAyWPwCBlobEJH6rnXfCC7o4dmIYCxkxfhqc1vivmKpelYgVgWgep/72LZibN6w9+QYRuAvF3kcfgNR1cZEEZ/ZDaX/7/QhZTX7ewsNp3tyrP'
    key    => "${public_key}",
  }
  ->
  file {"/etc/sudoers.d/vagrant":
    ensure => present,
    content => "vagrant ALL=(ALL) NOPASSWD:ALL",
  }
}