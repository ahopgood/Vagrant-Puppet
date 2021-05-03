class jekyll::ubuntu::bionic {
  $local_install_dir = "${jekyll::local_install_dir}"
  $puppet_file_dir = "${jekyll::puppet_file_dir}"

  # ruby -v > ruby 2.5.1p57 (2018-03-29 revision 63029) [x86_64-linux-gnu]
  # gem -v > 2.7.6
  # gcc version 7.4.0 (Ubuntu 7.4.0-1ubuntu1~18.04.1)
  # GNU Make 4.1

  notify{"In bionic":}

  $ruby_full_file_name = "ruby-full_1%3a2.5.1_all.deb"
  $ruby_full_package_name = "ruby-full"

  include jekyll::ubuntu::bionic::ruby
  realize(File["${ruby_full_file_name}"])
  realize(Package["${ruby_full_package_name}"])

  $build_essential_file_name = "build-essential_12.4ubuntu1_amd64.deb"
  $build_essential_package_name = "build-essential"
  file { "${build_essential_file_name}":
    ensure => present,
    path   => "${local_install_dir}${build_essential_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${build_essential_file_name}",
  }
  package { "${build_essential_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${build_essential_file_name}",
    require  => [
      File["${build_essential_file_name}"],
    ]
  }


  $zlib1g_dev_file_name = "zlib1g-dev_1%3a1.2.11.dfsg-0ubuntu2_amd64.deb"
  $zlib1g_dev_package_name = "zlib1g-dev"
  file { "${zlib1g_dev_file_name}":
    ensure => present,
    path   => "${local_install_dir}${zlib1g_dev_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${zlib1g_dev_file_name}",
  }
  package { "${zlib1g_dev_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${zlib1g_dev_file_name}",
    require  => [
      File["${zlib1g_dev_file_name}"],
    ]
  }

  #Jekyll install involves 24 gems
  #Match gem names
  #cat deps.txt | sed "s/\([a-z0-9-]\+\)\(.*\)/\1/"

  #sudo gem dependency jekyll -v 4.0.0 --pipe | sed "s/\([a-z0-9-]\+\) --version '\(.*\)'/\1/"

  $bundler_file_name = "bundler-2.1.4.gem"
  $bundler_package_name = "bundler"
  file { "${bundler_file_name}":
    ensure => present,
    path   => "${local_install_dir}${bundler_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${bundler_file_name}",
  }
  package { "${bundler_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${bundler_file_name}",
    require  => [
      File["${bundler_file_name}"],
    ]
  }

  $public_suffix_file_name = "public_suffix-4.0.4.gem"
  $public_suffix_package_name = "public_suffix"
  file { "${public_suffix_file_name}":
    ensure => present,
    path   => "${local_install_dir}${public_suffix_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${public_suffix_file_name}",
  }
  package { "${public_suffix_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${public_suffix_file_name}",
    require  => [
      File["${public_suffix_file_name}"],
    ]
  }

  $addressable_file_name = "addressable-2.7.0.gem"
  $addressable_package_name = "addressable"
  file { "${addressable_file_name}":
    ensure => present,
    path   => "${local_install_dir}${addressable_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${addressable_file_name}",
  }
  package { "${addressable_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${addressable_file_name}",
    require  => [
      File["${addressable_file_name}"],
      Package["${bundler_package_name}"],
      Package["${public_suffix_package_name}"],
    ]
  }

  $colorator_file_name = "colorator-1.1.0.gem"
  $colorator_package_name = "colorator"
  file { "${colorator_file_name}":
    ensure => present,
    path   => "${local_install_dir}${colorator_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${colorator_file_name}",
  }
  package { "${colorator_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${colorator_file_name}",
    require  => [
      File["${colorator_file_name}"],
    ]
  }

  $eventmachine_file_name = "eventmachine-1.2.7.gem"
  $eventmachine_package_name = "eventmachine"
  file { "${eventmachine_file_name}":
    ensure => present,
    path   => "${local_install_dir}${eventmachine_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${eventmachine_file_name}",
  }
  package { "${eventmachine_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${eventmachine_file_name}",
    require  => [
      File["${eventmachine_file_name}"],
    ]
  }

  $http_parser_file_name = "http_parser-0.1.3.gem"
  $http_parser_package_name = "http_parser"
  file { "${http_parser_file_name}":
    ensure => present,
    path   => "${local_install_dir}${http_parser_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${http_parser_file_name}",
  }
  package { "${http_parser_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${http_parser_file_name}",
    require  => [
      File["${http_parser_file_name}"],
    ]
  }
  $em_websocket_file_name = "em-websocket-0.5.1.gem"
  $em_websocket_package_name = "em-websocket"
  file { "${em_websocket_file_name}":
    ensure => present,
    path   => "${local_install_dir}${em_websocket_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${em_websocket_file_name}",
  }
  package { "${em_websocket_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${em_websocket_file_name}",
    require  => [
      File["${em_websocket_file_name}"],
      Package["${eventmachine_package_name}"],
      Package["${http_parser_package_name}"],
    ]
  }

  $concurrent_ruby_file_name = "concurrent-ruby-0.7.2-x86_64-linux.gem"
  $concurrent_ruby_package_name = "concurrent-ruby"
  file { "${concurrent_ruby_file_name}":
    ensure => present,
    path   => "${local_install_dir}${concurrent_ruby_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${concurrent_ruby_file_name}",
  }
  package { "${concurrent_ruby_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${concurrent_ruby_file_name}",
    require  => [
      File["${concurrent_ruby_file_name}"],
    ]
  }

  $i18n_file_name = "i18n-1.8.2.gem"
  $i18n_package_name = "i18n"
  file { "${i18n_file_name}":
    ensure => present,
    path   => "${local_install_dir}${i18n_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${i18n_file_name}",
  }
  package { "${i18n_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${i18n_file_name}",
    require  => [
      File["${i18n_file_name}"],
      Package["${concurrent_ruby_package_name}"],
    ]
  }

  $ffi_file_name = "ffi-1.12.2.gem"
  $ffi_package_name = "ffi"
  file { "${ffi_file_name}":
    ensure => present,
    path   => "${local_install_dir}${ffi_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${ffi_file_name}",
  }
  package { "${ffi_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${ffi_file_name}",
    require  => [
      File["${ffi_file_name}"],
    ]
  }

  $sassc_file_name = "sassc-2.1.0-x86_64-linux.gem"
  $sassc_package_name = "sassc"
  file { "${sassc_file_name}":
    ensure => present,
    path   => "${local_install_dir}${sassc_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${sassc_file_name}",
  }
  package { "${sassc_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${sassc_file_name}",
    require  => [
      File["${sassc_file_name}"],
      Package["${ffi_package_name}"],
    ]
  }

  $jekyll_sass_converter_file_name = "jekyll-sass-converter-2.1.0.gem"
  $jekyll_sass_converter_package_name = "jekyll-sass-converter"
  file { "${jekyll_sass_converter_file_name}":
    ensure => present,
    path   => "${local_install_dir}${jekyll_sass_converter_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${jekyll_sass_converter_file_name}",
  }
  package { "${jekyll_sass_converter_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${jekyll_sass_converter_file_name}",
    require  => [
      File["${jekyll_sass_converter_file_name}"],
      Package["${sassc_package_name}"],
    ]
  }

  $rb_inotify_file_name = "rb-inotify-0.10.1.gem"
  $rb_inotify_package_name = "rb-inotify"
  file { "${rb_inotify_file_name}":
    ensure => present,
    path   => "${local_install_dir}${rb_inotify_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${rb_inotify_file_name}",
  }
  package { "${rb_inotify_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${rb_inotify_file_name}",
    require  => [
      File["${rb_inotify_file_name}"],
    ]
  }

  $rb_fsevent_file_name = "rb-fsevent-0.10.3.gem"
  $rb_fsevent_package_name = "rb-fsevent"
  file { "${rb_fsevent_file_name}":
    ensure => present,
    path   => "${local_install_dir}${rb_fsevent_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${rb_fsevent_file_name}",
  }
  package { "${rb_fsevent_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${rb_fsevent_file_name}",
    require  => [
      File["${rb_fsevent_file_name}"],
    ]
  }

  $listen_file_name = "listen-3.2.1.gem"
  $listen_package_name = "listen"
  file { "${listen_file_name}":
    ensure => present,
    path   => "${local_install_dir}${listen_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${listen_file_name}",
  }
  package { "${listen_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${listen_file_name}",
    require  => [
      File["${listen_file_name}"],
      Package["${rb_inotify_package_name}"],
      Package["${rb_fsevent_package_name}"],
    ]
  }

  $jekyll_watch_file_name = "jekyll-watch-2.2.1.gem"
  $jekyll_watch_package_name = "jekyll-watch"
  file { "${jekyll_watch_file_name}":
    ensure => present,
    path   => "${local_install_dir}${jekyll_watch_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${jekyll_watch_file_name}",
  }
  package { "${jekyll_watch_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${jekyll_watch_file_name}",
    require  => [
      File["${jekyll_watch_file_name}"],
      Package["${listen_package_name}"],
    ]
  }

  $rexml_file_name = "rexml-3.2.4.gem"
  $rexml_package_name = "rexml"
  file { "${rexml_file_name}":
    ensure => present,
    path   => "${local_install_dir}${rexml_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${rexml_file_name}",
  }
  package { "${rexml_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${rexml_file_name}",
    require  => [
      File["${rexml_file_name}"],
    ]
  }

  $kramdown_file_name = "kramdown-2.2.1.gem"
  $kramdown_package_name = "kramdown"
  file { "${kramdown_file_name}":
    ensure => present,
    path   => "${local_install_dir}${kramdown_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${kramdown_file_name}",
  }
  package { "${kramdown_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${kramdown_file_name}",
    require  => [
      File["${kramdown_file_name}"],
      Package["${rexml_package_name}"],
    ]
  }

  $kramdown_parser_gfm_file_name = "kramdown-parser-gfm-1.1.0.gem"
  $kramdown_parser_gfm_package_name = "kramdown-parser-gfm"
  file { "${kramdown_parser_gfm_file_name}":
    ensure => present,
    path   => "${local_install_dir}${kramdown_parser_gfm_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${kramdown_parser_gfm_file_name}",
  }
  package { "${kramdown_parser_gfm_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${kramdown_parser_gfm_file_name}",
    require  => [
      File["${kramdown_parser_gfm_file_name}"],
      Package["${kramdown_package_name}"],
    ]
  }

  $liquid_file_name = "liquid-4.0.3.gem"
  $liquid_package_name = "liquid"
  file { "${liquid_file_name}":
    ensure => present,
    path   => "${local_install_dir}${liquid_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${liquid_file_name}",
  }
  package { "${liquid_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${liquid_file_name}",
    require  => [
      File["${liquid_file_name}"],
    ]
  }

  $mercenary_file_name = "mercenary-0.4.0.gem"
  $mercenary_package_name = "mercenary"
  file { "${mercenary_file_name}":
    ensure => present,
    path   => "${local_install_dir}${mercenary_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${mercenary_file_name}",
  }
  package { "${mercenary_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${mercenary_file_name}",
    require  => [
      File["${mercenary_file_name}"],
    ]
  }

  $forwardable_extended_file_name = "forwardable-extended-2.6.0.gem"
  $forwardable_extended_package_name = "forwardable-extended"
  file { "${forwardable_extended_file_name}":
    ensure => present,
    path   => "${local_install_dir}${forwardable_extended_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${forwardable_extended_file_name}",
  }
  package { "${forwardable_extended_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${forwardable_extended_file_name}",
    require  => [
      File["${forwardable_extended_file_name}"],
    ]
  }

  $pathutil_file_name = "pathutil-0.16.2.gem"
  $pathutil_package_name = "pathutil"
  file { "${pathutil_file_name}":
    ensure => present,
    path   => "${local_install_dir}${pathutil_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${pathutil_file_name}",
  }
  package { "${pathutil_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${pathutil_file_name}",
    require  => [
      File["${pathutil_file_name}"],
      Package["${forwardable_extended_package_name}"]
    ]
  }

  $rouge_file_name = "rouge-3.18.0.gem"
  $rouge_package_name = "rouge"
  file { "${rouge_file_name}":
    ensure => present,
    path   => "${local_install_dir}${rouge_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${rouge_file_name}",
  }
  package { "${rouge_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${rouge_file_name}",
    require  => [
      File["${rouge_file_name}"],
    ]
  }

  $safe_yaml_file_name = "safe_yaml-1.0.5.gem"
  $safe_yaml_package_name = "safe_yaml"
  file { "${safe_yaml_file_name}":
    ensure => present,
    path   => "${local_install_dir}${safe_yaml_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${safe_yaml_file_name}",
  }
  package { "${safe_yaml_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${safe_yaml_file_name}",
    require  => [
      File["${safe_yaml_file_name}"],
    ]
  }

  $unicode_display_width_file_name = "unicode-display_width-1.7.0.gem"
  $unicode_display_width_package_name = "unicode-display_width"
  file { "${unicode_display_width_file_name}":
    ensure => present,
    path   => "${local_install_dir}${unicode_display_width_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${unicode_display_width_file_name}",
  }
  package { "${unicode_display_width_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${unicode_display_width_file_name}",
    require  => [
      File["${unicode_display_width_file_name}"],
    ]
  }

  $terminal_table_file_name = "terminal-table-1.8.0.gem"
  $terminal_table_package_name = "terminal-table"
  file { "${terminal_table_file_name}":
    ensure => present,
    path   => "${local_install_dir}${terminal_table_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${terminal_table_file_name}",
  }
  package { "${terminal_table_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${terminal_table_file_name}",
    require  => [
      File["${terminal_table_file_name}"],
      Package["${unicode_display_width_package_name}"],
    ]
  }

  $jekyll_file_name = "jekyll-4.0.0.gem"
  $jekyll_package_name = "jekyll"
  file { "${jekyll_file_name}":
    ensure => present,
    path   => "${local_install_dir}${jekyll_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${jekyll_file_name}",
  }
  package { "${jekyll_package_name}":
    ensure   => installed,
    provider => gem,
    source   => "${local_install_dir}${jekyll_file_name}",
    require  => [
      File["${jekyll_file_name}"],
      Package["${ruby_full_package_name}"],
      Package["${build_essential_package_name}"],
      Package["${zlib1g_dev_package_name}"],
      Package["${addressable_package_name}"],
      Package["${colorator_package_name}"],
      Package["${em_websocket_package_name}"],
      Package["${i18n_package_name}"],
      Package["${jekyll_sass_converter_package_name}"],
      Package["${jekyll_watch_package_name}"],
      Package["${kramdown_package_name}"],
      Package["${kramdown_parser_gfm_package_name}"],
      Package["${liquid_package_name}"],
      Package["${mercenary_package_name}"],
      Package["${pathutil_package_name}"],
      Package["${rouge_package_name}"],
      Package["${safe_yaml_package_name}"],
      Package["${terminal_table_package_name}"],
    ]
  }
}

class jekyll::ubuntu::bionic::ruby {
  $local_install_dir = "${jekyll::local_install_dir}"
  $puppet_file_dir = "${jekyll::puppet_file_dir}"

  $libgmpxx4ldbl_file_name = "libgmpxx4ldbl_2%3a6.1.2+dfsg-2_amd64.deb"
  $libgmpxx4ldbl_package_name = "libgmpxx4ldbl"
  file { "${libgmpxx4ldbl_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libgmpxx4ldbl_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libgmpxx4ldbl_file_name}",
  }
  package { "${libgmpxx4ldbl_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libgmpxx4ldbl_file_name}",
    require  => [
      File["${libgmpxx4ldbl_file_name}"],
    ]
  }

  $libgmp_dev_file_name = "libgmp-dev_2%3a6.1.2+dfsg-2_amd64.deb"
  $libgmp_dev_package_name = "libgmp-dev"
  file { "${libgmp_dev_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libgmp_dev_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libgmp_dev_file_name}",
  }
  package { "${libgmp_dev_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${libgmp_dev_file_name}",
    require  => [
      File["${libgmp_dev_file_name}"],
      Package["${libgmpxx4ldbl_package_name}"],
    ]
  }

  $libruby_file_name = "libruby2.5_2.5.1-1ubuntu1.6_amd64.deb"
  $libruby_package_name = "libruby2.5"
  $ruby2_5_dev_package_name = "ruby2.5-dev"

  file { "${libruby_file_name}":
    ensure => present,
    path   => "${local_install_dir}${libruby_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${libruby_file_name}",
  }

  exec { "Install ${libruby_package_name} 1ubuntu1.6":
    path => ["/usr/bin","/bin/", "/sbin/"],
    command  => "dpkg -i ${local_install_dir}${libruby_file_name}",
    require => [
      File["${libruby_file_name}"],
    ],
    before => [
      Package["${ruby2_5_dev_package_name}"],
    ]
  }

  $ruby2_5_dev_file_name = "ruby2.5-dev_2.5.1-1ubuntu1.6_amd64.deb"

  file { "${ruby2_5_dev_file_name}":
    ensure => present,
    path   => "${local_install_dir}${ruby2_5_dev_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${ruby2_5_dev_file_name}",
  }
  package { "${ruby2_5_dev_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${ruby2_5_dev_file_name}",
    require  => [
      File["${ruby2_5_dev_file_name}"],
      Package["${libgmp_dev_package_name}"],
      Exec["Install ${libruby_package_name} 1ubuntu1.6"]
      # Package["${libruby_package_name}"],
    ]
  }

  $ruby_dev_file_name = "ruby-dev_1%3a2.5.1_amd64.deb"
  $ruby_dev_package_name = "ruby-dev"
  file { "${ruby_dev_file_name}":
    ensure => present,
    path   => "${local_install_dir}${ruby_dev_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${ruby_dev_file_name}",
  }
  package { "${ruby_dev_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${ruby_dev_file_name}",
    require  => [
      File["${ruby_dev_file_name}"],
      Package["${ruby2_5_dev_package_name}"],
    ]
  }

  $ruby2_5_doc_file_name = "ruby2.5-doc_2.5.1-1ubuntu1.6_all.deb"
  $ruby2_5_doc_package_name = "ruby2.5-doc"
  file { "${ruby2_5_doc_file_name}":
    ensure => present,
    path   => "${local_install_dir}${ruby2_5_doc_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${ruby2_5_doc_file_name}",
  }
  package { "${ruby2_5_doc_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${ruby2_5_doc_file_name}",
    require  => [
      File["${ruby2_5_doc_file_name}"],
    ]
  }

  $ri_file_name = "ri_1%3a2.5.1_all.deb"
  $ri_package_name = "ri"
  file { "${ri_file_name}":
    ensure => present,
    path   => "${local_install_dir}${ri_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${ri_file_name}",
  }
  package { "${ri_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${ri_file_name}",
    require  => [
      File["${ri_file_name}"],
      Package["${ruby2_5_doc_package_name}"],
    ]
  }

  $ruby_full_package_name = "${jekyll::ubuntu::bionic::ruby_full_package_name}"
  $ruby_full_file_name = "${jekyll::ubuntu::bionic::ruby_full_file_name}"

  @file { "${ruby_full_file_name}":
    ensure => present,
    path   => "${local_install_dir}${ruby_full_file_name}",
    source => "puppet:///${puppet_file_dir}${operatingsystem}/${operatingsystemmajrelease}/${ruby_full_file_name}",
  }
  @package { "${ruby_full_package_name}":
    ensure   => present,
    provider => dpkg,
    source   => "${local_install_dir}${ruby_full_file_name}",
    require  => [
      File["${ruby_full_file_name}"],
      Package["${ruby_dev_package_name}"],
      Package["${ri_package_name}"],
    ]
  }
}