Package{
  allow_virtual => false
}
  $local_install_path = "/etc/puppetlabs/code/environments/production/"
  $local_install_dir = "${local_install_path}installers/"

  file {
    "${local_install_dir}":
    path       =>  "${local_install_dir}",
    ensure     =>  directory,
  }
  
class {"plex":}
  
#RSS ShowRSS feed
#LINK:
#https://showrss.info/user/54139.rss?magnets=true&namespaces=true&name=clean&quality=hd&re=yes
#NAME:
#ShowRSS Feed