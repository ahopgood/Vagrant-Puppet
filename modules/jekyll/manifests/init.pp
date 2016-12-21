# Class: jekyll
#
# This module manages jekyll
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class jekyll {
  notify {
    "Jekyll and Hyde":
  }
  
  $local_install_path = "/etc/puppet/"
  $local_install_dir = "${local_install_path}installers/"
  $puppet_file_dir = "modules/jekyll/"
  
  file {"${local_install_dir}":
    ensure => directory,
  }
  
  $ruby_version = "1.8.7.374-4"
  $ruby_file = "ruby-${ruby_version}.el6_6.x86_64.rpm"
  $ruby_libs_version = "1.8.7.374-4"
  $ruby_libs_file = "ruby-libs-${ruby_version}.el6_6.x86_64.rpm"
  
  $python_libs_version = "2.6.6-64"
  $python_libs_file = "python-libs-${python_libs_version}.el6.x86_64.rpm"
  
  $python_version = "2.6.6-64"
  $python_file = "python-${python_version}.el6.x86_64.rpm"
  
  $glibc_i686_file = "glibc-2.12-1.166.el6.i686.rpm"
  $glibc_x64_file = "glibc-2.12-1.166.el6_7.3.x86_64.rpm"

  $rubygem_version = "1.3.7-5"
  $rubygem_file = "rubygems-${rubygem_version}.el6.noarch.rpm"

  $node_ver = "node-v4.2.0-linux-x64"
  $node_file_tar = "${node_ver}.tar"
  $node_file_gzip = "${node_file_tar}.gz"

  $patch_version = "3"
  $minor_version = "0"
  $major_version = "3"
  $jekyll_version = "jekyll-${major_version}.${minor_version}.${patch_version}"
  $jekyll_file_zip = "${jekyll_version}.zip"
/*
  file {"${$local_install_dir}${ruby_libs_file}":
    ensure => present,
    source => "puppet:///${puppet_file_dir}${ruby_libs_file}",
  }

  package {"ruby-libs":
    source => "${$local_install_dir}${ruby_libs_file}",
    provider => "rpm",
    ensure => present,
#    ensure => "${ruby_libs_version}"
  }
  
  file {"${$local_install_dir}${ruby_file}":
    ensure => present,
    source => "puppet:///${puppet_file_dir}${ruby_file}",
    require => File["${$local_install_dir}${ruby_libs_file}"]
  }
 
  #1.8.7 is the default for centos 6.6-64
  package {"ruby":
    source => "${$local_install_dir}${ruby_file}",
    provider => "rpm",
    ensure => present,
#    ensure => "${ruby_version}",
  }
  #requires ruby-libs 1.8.7.374-4.el6_6
  
  */ 
/*  
repoquery --require --resolve ruby
ruby-0:1.8.7.374-4.el6_6.x86_64
glibc-0:2.12-1.166.el6.i686
ruby-libs-0:1.8.7.374-4.el6_6.i686
ruby-libs-0:1.8.7.374-4.el6_6.x86_64
glibc-0:2.12-1.166.el6_7.3.x86_64
*/

/*
  file { "${local_install_dir}${glibc_i686_file}":
    ensure => present,
    source => "puppet:///${puppet_file_dir}${glibc_i686_file}"
  }

  package {"${glibc_i686_file}":
    source => "${local_install_dir}${glibc_i686_file}",
    provider => "rpm",
    ensure => present,
  }
*/
  #Need to try these installers without the fixed package names to see if we have all possible dependencies

  file {"${$local_install_dir}${python_libs_file}":
    ensure => present,
    source => "puppet:///${puppet_file_dir}${python_libs_file}",  
  }
  
  package {"python-libs":
    source => "${$local_install_dir}${python_libs_file}",
    provider => "rpm",
#    ensure => "{$python_libs_version}",
    ensure => present,
    require => File["${$local_install_dir}${python_libs_file}"] 
  }

  file {"${$local_install_dir}${python_file}":
    ensure => present,
    source => "puppet:///${puppet_file_dir}${$python_file}",
  } 

  package {"python":
    source => "${$local_install_dir}${python_file}",
    provider => "rpm",
#    ensure => "${python_version}",
    ensure => present,
    require => [File["${$local_install_dir}${python_file}"],
      Package["python-libs"]]
#      Package["glibc"]]
  }
  #requires python-libs(x86-64) = 2.6.6-64.el6
  #Supplied already apparently
/*
repoquery --require --resolve python
python-0:2.6.6-64.el6.x86_64
glibc-0:2.12-1.166.el6.i686
python-libs-0:2.6.6-64.el6.x86_64
glibc-0:2.12-1.166.el6_7.3.x86_64
*/   
/*     
  file {"${$local_install_dir}${rubygem_file}":
    ensure => present,
    source => "puppet:///${puppet_file_dir}${$rubygem_file}",  
  }
  
  package {"rubygems":
    source => "${local_install_dir}${rubygem_file}",
    provider => "rpm",
    ensure => present,
#    ensure => "${rubygem_version}"
  }
*/
/*
  file {"${$local_install_dir}${node_file_gzip}":
    ensure => present,
    source => ["puppet:///${puppet_file_dir}${node_file_gzip}"]  
  }
  
  exec{"gunzip of node":
    cwd => "/bin/",
    path => "/bin/",
    command => "gunzip -dc ${local_install_dir}${node_file_gzip} > ${local_install_dir}${node_file_tar}",
    require => File["${$local_install_dir}${node_file_gzip}"]
  }

  #Move node to /bin/ folder
  exec {"tar decompression of node":
    cwd => "/bin/",
    path => "/bin/",
    command => "tar -xf ${local_install_dir}${node_file_tar}",
    require => Exec["gunzip of node"]
  }
  #link to the node install
  #sudo ln -s /etc/puppet/installers/node-v4.2.0-linux-x64/bin/node /bin/node
  
  */
/*
  #Install rake so that we can build bundler
  $rake_gem = "rake-10.5.0.gem"
  file {"${local_install_dir}${rake_gem}":
    ensure => present,
    mode => 777,
    source => ["puppet:///${puppet_file_dir}${$rubygem_file}"] 
  }
  
  #Install bundler so that we can build jekyll
  $bundler_gem =  "bundler-1.11.2.gem"
  file {"${local_install_dir}${bundler_gem}":
     ensure => present,
     mode => 777,
     source => ["puppet:///${puppet_file_dir}${bundler_gem}"]
  }
  */
  #chmod /usr/bin and /usr/lib to install bundler as non-root
  
  #Unzip jekyll  
  file {"${local_install_dir}${jekyll_file_zip}":
    ensure => present,
    mode => 777,
    source => ["puppet:///${puppet_file_dir}${jekyll_file_zip}"],
  }
  
  exec {"unzip jekyll":
    cwd => "/usr/bin/",
    path => "/usr/bin/",
    command => "unzip -o ${local_install_dir}${jekyll_file_zip}",
    require => File["${local_install_dir}${jekyll_file_zip}"]
  }
  
  #bundler is required before jekyll can be run, this is built using  
  #Need to check out bundler from the git repository and build it
  #git clone git://github.com/carlhuda/bundler.git
  #cd bundler
  #rake install

  #cd jekyll
  #sh script/bootstrap
  #exec script/bootstrap
  #bundle exec rake build
  #ls pkg/*.gem | head -n 1 | xargs gem install -l
  
  #bundle is provided by ruby on rails
  #Ruby 2.2.3
  #Ruby Gems 2.4.8
  #Node 4.2.0
  #Python
  
  $ruby_archive = "ruby-2.3.0.tar.gz"
  file {"${local_install_dir}${ruby_archive}":
    ensure => present,
    source => ["puppet:///${puppet_file_dir}${ruby_archive}"]
  }

  $ruby_gem_archive = "rubygems-2.6.0.tar.gz"
  file {"${local_install_dir}${ruby_gem_archive}":
    ensure => present,
    source => ["puppet:///${puppet_file_dir}${ruby_gem_archive}"]
  }

  file {"${local_install_dir}ruby.sh":
    ensure => present,
    source => ["puppet:///${puppet_file_dir}ruby.sh"]
  }

  #install ruby and rubygems
/* 
  exec {"run ruby.sh":
    cwd => "/usr/bin/",
    path => "/usr/bin/",
    command => "sudo sh /etc/puppet/installers/ruby.sh",
  }  
*/
  #Unzip the ruby.tar.gz
  #tar xvzf ruby.tar.gz
  #chmod 777 -R ruby
  #cd ruby
  #./configure
  #make
  #sudo make install
  
  #sudo tar xvzf rubygems.tar.gz
  #cd rubygems
  #sudo ruby setup.rb
  
  #try using RVM to update ruby
  #sudo gem install ffi*.gem -> requires the ruby devel headers
  #sudo gem install rb-inotify*.gem
  #sudo gem install listen*.gem
  #sudo gem install jekyll-watch*.gem
  #sudo gem install jekyll.gem

}
