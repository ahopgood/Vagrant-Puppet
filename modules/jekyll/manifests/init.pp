class jekyll (
  $blog_source_directory = "/blog/",
  $blog_output_directory = "/published_blog/",
  $blog_host_address = "192.168.33.25",
  $showDrafts = "false",
  $showFuture = "false"
) {
  $local_install_path = "/etc/puppet/"
  $local_install_dir = "${local_install_path}installers/"
  $puppet_file_dir = "modules/jekyll/"

  file {"${local_install_dir}":
    ensure => directory,
  }

  if ("${operatingsystem}" == "Ubuntu"){
    if ("${operatingsystemmajrelease}" == "15.10"){
      notify{"Installing Jekyll for ${operatingsystem} ${operatingsystemmajrelease}":}
      $addressable_gem_file = "addressable-2.5.0.gem"
      file {"${addressable_gem_file}":
        ensure => present,
        path => "${local_install_dir}${addressable_gem_file}",
        source => "puppet:///${puppet_file_dir}${addressable_gem_file}",
      }

      package { 'addressable':
        source => "${local_install_dir}${addressable_gem_file}",
        ensure   => 'installed',
        provider => 'gem',
      }

      $colorator_gem_file = "colorator-1.1.0.gem"
      file {"${colorator_gem_file}":
        ensure => present,
        path => "${local_install_dir}${colorator_gem_file}",
        source => "puppet:///${puppet_file_dir}${colorator_gem_file}",
      }
      package { 'colorator':
        source => "${local_install_dir}${colorator_gem_file}",
        ensure   => 'installed',
        provider => 'gem',
      }

      $ffi_gem_file = "ffi-1.9.14.gem"
      file {"${ffi_gem_file}":
        ensure => present,
        path => "${local_install_dir}${ffi_gem_file}",
        source => "puppet:///${puppet_file_dir}${ffi_gem_file}",
      }
      package { 'ffi':
        source => "${local_install_dir}${ffi_gem_file}",
        ensure   => 'installed',
        provider => 'gem',
      }

      $forwardable_extended_gem_file = "forwardable-extended-2.6.0.gem"
      file {"${forwardable_extended_gem_file}":
        ensure => present,
        path => "${local_install_dir}${forwardable_extended_gem_file}",
        source => "puppet:///${puppet_file_dir}${forwardable_extended_gem_file}",
      }
      package { 'forwardable-extended':
        source => "${local_install_dir}${forwardable_extended_gem_file}",
        ensure   => 'installed',
        provider => 'gem',
      }

      $jekyll_gem_file = "jekyll-3.3.1.gem"
      file {"${jekyll_gem_file}":
        ensure => present,
        path => "${local_install_dir}${jekyll_gem_file}",
        source => "puppet:///${puppet_file_dir}${jekyll_gem_file}",
      }
      package { 'jekyll':
        source => "${local_install_dir}${jekyll_gem_file}",
        ensure   => 'installed',
        provider => 'gem',
        install_options => ["--force"],
        require => [
          Package["addressable"],
          Package["colorator"],
          Package["ffi"],
          Package["forwardable-extended"],
          Package["jekyll-sass-converter"],
          Package["jekyll-watch"],
          Package["kramdown"],
          Package["liquid"],
          Package["listen"],
          Package["mercenary"],
          Package["pathutil"],
          Package["public_suffix"],
          Package["rb-fsevent"],
          Package["rb-inotify"],
          Package["rouge"],
          Package["safe_yaml"],
          Package["sass"],
          Package["sass-listen"],
        ]
      }

      $jekyll_sass_converter_gem_file = "jekyll-sass-converter-1.5.0.gem"
      file {"${jekyll_sass_converter_gem_file}":
        ensure => present,
        path => "${local_install_dir}${jekyll_sass_converter_gem_file}",
        source => "puppet:///${puppet_file_dir}${jekyll_sass_converter_gem_file}",
      }
      package { 'jekyll-sass-converter':
        source => "${local_install_dir}${jekyll_sass_converter_gem_file}",
        ensure   => 'installed',
        provider => 'gem',
        install_options => ["--force"],
        #    before => Package["listen"],
        require => Package["sass"],
      }

      $jekyll_watch_gem_file = "jekyll-watch-1.5.0.gem"
      file {"${jekyll_watch_gem_file}":
        ensure => present,
        path => "${local_install_dir}${jekyll_watch_gem_file}",
        source => "puppet:///${puppet_file_dir}${jekyll_watch_gem_file}",
      }
      package { 'jekyll-watch':
        source => "${local_install_dir}${jekyll_watch_gem_file}",
        ensure   => 'installed',
        provider => 'gem',
        require => Package["listen"],
      }

      $kramdown_gem_file = "kramdown-1.13.2.gem"
      file {"${kramdown_gem_file}":
        ensure => present,
        path => "${local_install_dir}${kramdown_gem_file}",
        source => "puppet:///${puppet_file_dir}${kramdown_gem_file}",
      }
      package { 'kramdown':
        source => "${local_install_dir}${kramdown_gem_file}",
        ensure   => 'installed',
        provider => 'gem',
      }

      $liquid_gem_file = "liquid-3.0.6.gem"
      file {"${liquid_gem_file}":
        ensure => present,
        path => "${local_install_dir}${liquid_gem_file}",
        source => "puppet:///${puppet_file_dir}${liquid_gem_file}",
      }
      package { 'liquid':
        source => "${local_install_dir}${liquid_gem_file}",
        ensure   => 'installed',
        provider => 'gem',
      }

      $listen_gem_file = "listen-3.0.8.gem"
      file {"${listen_gem_file}":
        ensure => present,
        path => "${local_install_dir}${listen_gem_file}",
        source => "puppet:///${puppet_file_dir}${listen_gem_file}",
      }
      package { 'listen':
        source => "${local_install_dir}${listen_gem_file}",
        ensure   => 'installed',
        provider => 'gem',
        require => Package["rb-inotify"],
      }

      $mercenary_gem_file = "mercenary-0.3.6.gem"
      file {"${mercenary_gem_file}":
        ensure => present,
        path => "${local_install_dir}${mercenary_gem_file}",
        source => "puppet:///${puppet_file_dir}${mercenary_gem_file}",
      }
      package { 'mercenary':
        source => "${local_install_dir}${mercenary_gem_file}",
        ensure   => 'installed',
        provider => 'gem',
      }

      $pathutil_gem_file = "pathutil-0.14.0.gem"
      file {"${pathutil_gem_file}":
        ensure => present,
        path => "${local_install_dir}${pathutil_gem_file}",
        source => "puppet:///${puppet_file_dir}${pathutil_gem_file}",
      }
      package { 'pathutil':
        source => "${local_install_dir}${pathutil_gem_file}",
        ensure   => 'installed',
        provider => 'gem',
      }

      $public_suffix_gem_file = "public_suffix-2.0.5.gem"
      file {"${public_suffix_gem_file}":
        ensure => present,
        path => "${local_install_dir}${public_suffix_gem_file}",
        source => "puppet:///${puppet_file_dir}${public_suffix_gem_file}",
      }
      package { 'public_suffix':
        source => "${local_install_dir}${public_suffix_gem_file}",
        ensure   => 'installed',
        provider => 'gem',
      }

      $rb_fsevent_gem_file = "rb-fsevent-0.9.8.gem"
      file {"${rb_fsevent_gem_file}":
        ensure => present,
        path => "${local_install_dir}${rb_fsevent_gem_file}",
        source => "puppet:///${puppet_file_dir}${rb_fsevent_gem_file}",
      }
      package { 'rb-fsevent':
        source => "${local_install_dir}${rb_fsevent_gem_file}",
        ensure   => 'installed',
        provider => 'gem',
      }

      $rb_inotify_gem_file = "rb-inotify-0.9.7.gem"
      file {"${rb_inotify_gem_file}":
        ensure => present,
        path => "${local_install_dir}${rb_inotify_gem_file}",
        source => "puppet:///${puppet_file_dir}${rb_inotify_gem_file}",
      }
      package { 'rb-inotify':
        source => "${local_install_dir}${rb_inotify_gem_file}",
        ensure   => 'installed',
        provider => 'gem',
      }

      $rouge_gem_file = "rouge-1.11.1.gem"
      file {"${rouge_gem_file}":
        ensure => present,
        path => "${local_install_dir}${rouge_gem_file}",
        source => "puppet:///${puppet_file_dir}${rouge_gem_file}",
      }
      package { 'rouge':
        source => "${local_install_dir}${rouge_gem_file}",
        ensure   => 'installed',
        provider => 'gem',
      }

      $safe_yaml_gem_file = "safe_yaml-1.0.4.gem"
      file {"${safe_yaml_gem_file}":
        ensure => present,
        path => "${local_install_dir}${safe_yaml_gem_file}",
        source => "puppet:///${puppet_file_dir}${safe_yaml_gem_file}",
      }
      package { 'safe_yaml':
        source => "${local_install_dir}${safe_yaml_gem_file}",
        ensure   => 'installed',
        provider => 'gem',
      }

      $sass_gem_file = "sass-3.5.0.pre.rc.1.gem"
      file {"${sass_gem_file}":
        ensure => present,
        path => "${local_install_dir}${sass_gem_file}",
        source => "puppet:///${puppet_file_dir}${sass_gem_file}",
      }
      package { 'sass':
        source => "${local_install_dir}${sass_gem_file}",
        ensure   => 'installed',
        provider => 'gem',
      }

      $sass_listen_gem_file = "sass-listen-3.0.7.gem"
      file {"${sass_listen_gem_file}":
        ensure => present,
        path => "${local_install_dir}${sass_listen_gem_file}",
        source => "puppet:///${puppet_file_dir}${sass_listen_gem_file}",
      }
      package { 'sass-listen':
        source => "${local_install_dir}${sass_listen_gem_file}",
        ensure   => 'installed',
        provider => 'gem',
        install_options => ["--force"],
      }
    } elsif ("${operatingsystemmajrelease}" == "18.04") {
      class {"jekyll::ubuntu::bionic":}
    } else {
      fail("The version ${operatingsystemmajrelease} of ${operatingsystem} is not supported")
    }
  } else {
    fail("${operatingsystem} is not supported")
  }

  # Possible reusable code

  if ("${showDrafts}" == "true"){
    $drafts = "--drafts"
  } else {
    $drafts = ""
  }
  if ("${showFuture}" == "true"){
    $future = "--future"
  } else {
    $future = ""
  }

  #  exec {"stop-jekyll":
  #    path => "/usr/local/bin/",
  #    command => "/bin/bash /usr/local/bin/jekyll.sh stop",
  #    require => [
  #      File["jekyll.sh"],
  #    ],
  #    onlyif => "/bin/ps -aux | /bin/grep jekyll | /bin/grep -v grep",
  #  }
  #
  file { "jekyll.sh":
    path    => "/usr/local/bin/jekyll.sh",
    ensure  =>  present,
    mode => "0755",
    content => template("${module_name}/jekyll.sh.erb")
  }
  #
  #  exec {"start-jekyll-server":
  #    path => "/usr/local/bin/",
  #    command => "/bin/bash /usr/local/bin/jekyll.sh start &",
  #    require => [
  #      File["jekyll.sh"],
  #      Package["jekyll"]
  #    ]
  #  }

  $jekyll_service_file="jekyll.service"
  file {"${jekyll_service_file}":
    ensure => present,
    path => "${local_install_dir}${jekyll_service_file}",
    source => "puppet:///${puppet_file_dir}${jekyll_service_file}",
  }

  exec {"set-jekyll-as-a-service":
    path => "/bin/",
    command => "systemctl enable ${local_install_dir}${jekyll_service_file}",
    require => [
      File["jekyll.sh"],
      File["${jekyll_service_file}"],
      Package["jekyll"]
    ]
  }
  ->
  service {"jekyll":
    ensure => "running",
    require => Exec["set-jekyll-as-a-service"]
  }

  #exec
  #jekyll serve --host 192.168.33.25 -s /blog/ -d /published_blog/ --watch --drafts --force_polling

  #get pid of jekyll
  #ps -aux | grep jekyll | grep -v grep | awk '{ print $2 }'
  #Kill jekyll
  #pkill -f jekyll

  #Note serve's --detach option breaks incremental builds
}