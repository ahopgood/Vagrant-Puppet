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
  
  $ruby_file = "ruby-1.8.7.374-4.el6_6.x86_64.rpm"
  $python_file = "python-2.6.6-64.el6.x86_64.rpm"
  $rubygem_file = "rubygems-1.3.7-5.el6.noarch.rpm"
  $node_file = "node-v4.2.0-linux-x64.tar.gz"
  
  file {["${$local_install_dir}${ruby_file}",
    "${$local_install_dir}${python_file}",
    "${$local_install_dir}${rubygem_file}"]:
#    "${$local_install_dir}${node_file}"]:
    ensure => present,
    source => ["puppet:///${puppet_file_dir}${ruby_file}",
      "puppet:///${puppet_file_dir}${$python_file}",
      "puppet:///${puppet_file_dir}${$rubygem_file}"]
 #     "puppet:///${puppet_file_dir}${node_file}"]  
  }

  #Ruby 2.2.3
  #Ruby Gems 2.4.8
  #Node 4.2.0
  #Python
}
