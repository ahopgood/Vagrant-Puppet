# Class: wordpress
#
# This module manages wordpress
#
# Parameters: none
#
# Actions:
#
# Requires: see Modulefile
#
# Sample Usage:
#
class wordpress (
  $major_version = '4',
  $minor_version = '3',
  $patch_version = '1'
) {
  Class["mysql"] -> Class["kanboard"]
  #Set firewall port in iptables
  #
  #Install mysql
  #Setup wordpress database
  #Setup root user and password on mysql
  #
  #Unzipping of wordpres-4.3.1.tar.gz into html shared folder
  
}
